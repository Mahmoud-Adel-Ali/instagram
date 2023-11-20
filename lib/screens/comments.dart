// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constant/colors.dart';
import 'package:instagram/firebase_services/firestore.dart';
import 'package:instagram/provider/userData.dart';
import 'package:instagram/shared/decrationOfTextFeild.dart';
import 'package:instagram/shared/toastMessag.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final Map data;
  final bool showTextFeild;
  const CommentPage(
      {super.key, required this.data, required this.showTextFeild});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context, listen: false).getUser;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          screenWidth >= 600 ? webBackgroundColor : mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            screenWidth >= 600 ? webBackgroundColor : mobileBackgroundColor,
        title: const Text(
          "Comments",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: screenWidth >= 600,
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth >= 600 ? 2 * screenWidth / 3 : double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //===========get all comment from DB

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("postss")
                    .doc(widget.data['postId'])
                    .collection("comments")
                    .orderBy("datePublished",
                        descending: false) //descending تنازلي
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }

                  return Expanded(
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(5),
                          // color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(right: 12),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      data['ProfilePicture']
                                      // "https://i.pinimg.com/564x/94/df/a7/94dfa775f1bad7d81aa9898323f6f359.jpg",
                                      ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(data['username']),
                                  Text(data['comment']),
                                  Text(
                                    (data["datePublished"].toDate() ==
                                            DateTime.now())
                                        ? "now"
                                        : DateFormat("MMM/dd/y _ hh:mm a")
                                            .format(
                                                data["datePublished"].toDate()),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.favorite))
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),

              //==========================

              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(5),
                // color: Colors.amber,
                height: 70,
                child: widget.showTextFeild
                    ? Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 12),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(
                                userData!.ProfileImage,
                                // "https://i.pinimg.com/564x/94/df/a7/94dfa775f1bad7d81aa9898323f6f359.jpg",
                              ),
                            ),
                          ),
                          Expanded(
                              child: TextFormField(
                            controller: commentController,
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            style: const TextStyle(color: Colors.black),
                            decoration: decorationTextfield.copyWith(
                                hintText: "comment :${userData.userName}",
                                hintStyle: TextStyle(color: Colors.black),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (commentController.text.isNotEmpty) {
                                      FirestoreClass().uploadComment(
                                          context: context,
                                          commentController: commentController,
                                          postId: widget.data['postId']);
                                      commentController.clear();
                                    } else {
                                      toastMessag(
                                          msg: "you should write comment",
                                          myColor: Colors.redAccent);
                                    }
                                  },
                                  icon: Icon(Icons.send),
                                )),
                          ))
                        ],
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
