// ignore_for_file: file_names, use_build_context_synchronously, unnecessary_brace_in_string_interps

// import 'dart:html';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constant/colors.dart';
import 'package:instagram/firebase_services/firestore.dart';
import 'package:instagram/screens/comments.dart';
import 'package:instagram/screens/profile.dart';
import 'package:instagram/shared/heart_animation.dart';
import 'package:instagram/shared/toastMessag.dart';
import 'package:intl/intl.dart';

class PostDesigne extends StatefulWidget {
  final Map<String, dynamic> data;
  const PostDesigne({super.key, required this.data});

  @override
  State<PostDesigne> createState() => _PostDesigneState();
}

class _PostDesigneState extends State<PostDesigne> {
  postDialog({required String uiddd, required context}) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            color: Colors.white,
            width: 2 * MediaQuery.of(context).size.width / 3,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                uiddd == FirebaseAuth.instance.currentUser!.uid
                    ? TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            await FirebaseFirestore.instance
                                .collection("postss")
                                .doc(widget.data['postId'])
                                .delete();
                            toastMessag(
                                msg: "post deleted", myColor: Colors.green);
                          } on FirebaseAuthException catch (e) {
                            toastMessag(
                                msg: e.toString(), myColor: Colors.redAccent);
                            // to delete dialog page
                          } catch (e) {
                            toastMessag(msg: e.toString(), myColor: Colors.red);
                          }
                        },
                        child: const Text("delete my post",
                            style: TextStyle(fontSize: 22)))
                    : const Text("✌🤞🙌", style: TextStyle(fontSize: 22)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Text("cancel", style: TextStyle(fontSize: 22))),
              ],
            ),
          ),
        );
      },
    );
  }

  bool showHeart = false;
  bool postLike = false;
  int commentCount = 0;
  bool isLikeAnimating = false;
  getCommentCount() async {
    try {
      QuerySnapshot commentData = await FirebaseFirestore.instance
          .collection("postss")
          .doc(widget.data['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentCount = commentData.docs.length;
      });
    } catch (e) {
      toastMessag(msg: e.toString(), myColor: Colors.red);
    }
  }

  onClickOnPicture() async {
    setState(() {
      isLikeAnimating = true;
      showHeart = true;
      postLike = true;
    });
    await FirebaseFirestore.instance
        .collection("postss")
        .doc(widget.data['postId'])
        .update(
      {
        "likes": FieldValue.arrayUnion(
          [FirebaseAuth.instance.currentUser!.uid],
        ),
      },
    );
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        showHeart = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    postLike =
        widget.data['likes'].contains(FirebaseAuth.instance.currentUser!.uid);
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: mobileBackgroundColor,
          borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(
          vertical: 11, horizontal: screenWidth > 600 ? screenWidth / 6 : 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Profile(uidd: widget.data['uid']),
                        ));
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(125, 78, 91, 110),
                        ),
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: NetworkImage(
                            widget.data["profileImg"],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 17,
                      ),
                      Text(
                        // widget.snap["username"],
                        widget.data['userName'],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      postDialog(uiddd: widget.data['uid'], context: context);
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 9, 10),
            width: screenWidth >= 60 ? 2 * screenWidth / 3 : double.infinity,
            child: Text(
              widget.data["description"],
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () async {
                  await onClickOnPicture();
                },
                child: SizedBox(
                  height: screenWidth >= 60 ? 400 : 300,
                  child: Image.network(
                    widget.data["imgPost"],
                    // "https://cdn1-m.alittihad.ae/store/archi11ve/image/2021/10/22/6266a092-72dd-4a2f-82a4-d22ed9d2cc59.jpg?width=1300",
                    fit: BoxFit.cover,
                    height: 320,
                    width: double.infinity,
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white));
                    },
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 111,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.data['likes']
                          .contains(FirebaseAuth.instance.currentUser!.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          FirestoreClass().clickLikeOrNot(
                              likes: widget.data['likes'],
                              postId: widget.data['postId']);
                          setState(() {
                            postLike = !postLike;
                          });
                        },
                        icon: widget.data['likes'].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentPage(
                                data: widget.data,
                                showTextFeild: true,
                              ),
                            ));
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_outline),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
            width: double.infinity,
            child: Text(
              "${widget.data['likes'].length.toString()} like${widget.data['likes'].length > 1 ? "s" : ""}",
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 9),
              Text(
                // "${widget.snap["username"]}",
                widget.data["userName"],
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 189, 196, 199)),
              ),
              const Text(
                // " ${widget.snap["description"]}",
                " Sidi Bou Said ♥",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 189, 196, 199)),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentPage(
                      data: widget.data,
                      showTextFeild: false,
                    ),
                  ));
            },
            child: Container(
                margin: const EdgeInsets.fromLTRB(10, 13, 9, 10),
                width: double.infinity,
                child: Text(
                  "View all ${commentCount} comments",
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.start,
                )),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 9, 10),
            width: double.infinity,
            child: Text(
              // data["datePublished"].toString(),
              DateFormat("MMMM/dy _ hh:mm a")
                  .format(widget.data["datePublished"].toDate())
                  .toString(),
              style: const TextStyle(
                  fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
