import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/constant/colors.dart';
import 'package:instagram/firebase_services/auth.dart';
import 'package:instagram/screens/signIn.dart';
import 'package:instagram/shared/decrationOfTextFeild.dart';
import 'package:instagram/shared/toastMessag.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool hiddinPassword = true;
  final password = TextEditingController();
  final emailAddress = TextEditingController();
  final jop = TextEditingController();
  final userName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Uint8List? imgPath;
  late String imgName;
  String url =
      "https://tse4.mm.bing.net/th?id=OIP.qgvE8Nd8S9_T0ioggfZWcAHaHw&pid=Api&P=0&h=220";

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
                      style: TextStyle(fontSize: 20),
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
                    const Text("Files", style: TextStyle(fontSize: 20)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  clickOnRegister() async {
    if (_formKey.currentState!.validate()) {
      await AuthClass(context: context).register(
          emailAddress: emailAddress,
          password: password,
          userName: userName,
          jop: jop,
          imgName: imgName,
          imgPath: imgPath);
      if (!mounted) return;
    }
  }

  @override
  void dispose() {
    password.dispose();
    emailAddress.dispose();
    jop.dispose();
    userName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          screenWidth >= 60 ? webBackgroundColor : mobileBackgroundColorSR,
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mobileBackgroundColorSR,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: screenWidth >= 600 ? screenWidth / 2 : double.infinity,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(children: [
                      Container(
                        height: 220,
                        width: 200,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.amber),
                        child: imgPath != null
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(imgPath!),
                              )
                            : const CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/img/th.jpeg"),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            myDialog();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 30),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty
                            ? "you should fill your name"
                            : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: userName,
                      maxLength: 30,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      style: const TextStyle(color: Colors.black),
                      decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your Name : ",
                        hintStyle: TextStyle(
                            color: screenWidth >= 600
                                ? webBackgroundColor
                                : mobileBackgroundColorSR),
                        suffix: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty
                            ? "you should fill your jop"
                            : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: jop,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your jop : ",
                        hintStyle: TextStyle(
                            color: screenWidth >= 600
                                ? webBackgroundColor
                                : mobileBackgroundColorSR),
                        suffix: Icon(Icons.title,
                            color: screenWidth >= 600
                                ? webBackgroundColor
                                : mobileBackgroundColorSR),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        return value!.contains(RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                            ? null
                            : "Enter a valid email";
                      },
                      style: const TextStyle(color: Colors.black),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailAddress,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your Email : ",
                        hintStyle: TextStyle(
                            color: screenWidth >= 600
                                ? webBackgroundColor
                                : mobileBackgroundColorSR),
                        suffix: Icon(Icons.email,
                            color: screenWidth >= 600
                                ? webBackgroundColor
                                : mobileBackgroundColorSR),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        return value!.length < 8
                            ? "Enter a valid password : at least 8 chracter"
                            : null;
                      },
                      style: const TextStyle(color: Colors.black),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: password,
                      keyboardType: TextInputType.text,
                      obscureText: hiddinPassword,
                      decoration: decorationTextfield.copyWith(
                        // prefixIcon: Icon(Icons.password),
                        hintText: "Enter Your Password : ",
                        hintStyle: TextStyle(
                            color: screenWidth >= 600
                                ? webBackgroundColor
                                : mobileBackgroundColorSR),

                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              hiddinPassword = !hiddinPassword;
                            });
                          },
                          icon: hiddinPassword
                              ? Icon(Icons.visibility,
                                  color: screenWidth >= 600
                                      ? webBackgroundColor
                                      : mobileBackgroundColorSR)
                              : Icon(Icons.visibility_off,
                                  color: screenWidth >= 600
                                      ? webBackgroundColor
                                      : mobileBackgroundColorSR),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        clickOnRegister();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 122, 3, 3))),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "if you have acount ",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => const SignIn()),
                                ),
                              );
                            },
                            child: const Text(
                              "signIn",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 25,
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
