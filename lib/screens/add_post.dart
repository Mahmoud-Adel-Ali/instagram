// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:typed_data';
import 'package:instagram/firebase_services/firestore.dart';
import 'package:instagram/provider/userData.dart';
import 'package:instagram/shared/toastMessag.dart';
import 'package:path/path.dart' show basename;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/constant/colors.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? imgPath;
  String? imgName;
  bool linuerProgressLoading = false;
  final description = TextEditingController();

  uploadImage(ImageSource imageSource) async {
    final XFile? pickedImg = await ImagePicker().pickImage(source: imageSource);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
        setState(() {
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        toastMessag(msg: "NO img selected", myColor: Colors.redAccent);
      }
    } catch (e) {
      toastMessag(msg: "Error => $e", myColor: Colors.redAccent);
    }
  }

  myDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          uploadImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.edit)),
                    const Text(
                      "Camera",
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          uploadImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.file_open)),
                    const Text("Files",
                        style: TextStyle(fontSize: 20, color: Colors.blue)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB =
        Provider.of<UserProvider>(context, listen: false).getUser;
    final double screenWidth = MediaQuery.of(context).size.width;
    return imgPath != null
        ? Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        linuerProgressLoading = true;
                      });
                      await FirestoreClass().uploadPost(
                        description: description.text,
                        userName: allDataFromDB?.userName,
                        profileImg: allDataFromDB!.ProfileImage,
                        imgName: imgName,
                        imgPath: imgPath,
                        context: context,
                      );
                      setState(() {
                        linuerProgressLoading = false;
                        imgPath = null;
                      });
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    )),
              ],
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      imgPath = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    linuerProgressLoading
                        ? const LinearProgressIndicator()
                        : const Divider(
                            thickness: 1,
                            color: mobileBackgroundColorSR,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          margin: const EdgeInsets.only(left: 40),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          child: CircleAvatar(
                            radius: 33,
                            backgroundImage:
                                NetworkImage(allDataFromDB!.ProfileImage),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                            controller: description,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Write any discription......",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.memory(imgPath!),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor:
                screenWidth >= 600 ? webBackgroundColor : mobileBackgroundColor,
            body: Center(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: screenWidth >= 600 ? screenWidth / 2 : double.infinity,
                  child: TextButton.icon(
                      onPressed: () {
                        myDialog();
                      },
                      icon: const Icon(
                        Icons.upload,
                        size: 50,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "upload post",
                        style: TextStyle(color: Colors.white),
                      ))),
            ),
          );
  }
}
