import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/firebase_services/storage.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/provider/userData.dart';
import 'package:instagram/shared/toastMessag.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FirestoreClass {
  uploadPost({
    required description,
    required userName,
    required profileImg,
    required imgName,
    required imgPath,
    required context,
  }) async {
    try {
      //----------------------------------------
      String url = await getImgUrl(
          imgName: imgName,
          imgPath: imgPath,
          folderName: 'imgPosts/${FirebaseAuth.instance.currentUser!.uid}');
      //----------------------------------------
      String newId = const Uuid().v1();
      CollectionReference posts =
          FirebaseFirestore.instance.collection("postss");
      //variable from PostData
      PostData posttt = PostData(
        profileImg: profileImg,
        userName: userName,
        description: description,
        imgPost: url,
        uid: FirebaseAuth.instance.currentUser!.uid,
        postId: newId,
        datePublished: DateTime.now(),
        likes: [],
      );
      // add details of use to firebase firestor
      posts
          .doc(newId)
          .set(posttt.convert2Map())
          .then(
              (value) => toastMessag(msg: 'post added.', myColor: Colors.greenAccent))
          .catchError((error) =>
              toastMessag(msg: 'faild to add post', myColor: Colors.red));
    } on FirebaseAuthException catch (e) {
      toastMessag(msg: e.toString(), myColor: Colors.redAccent);
      // to delete dialog page
    } catch (e) {
      toastMessag(msg: e.toString(), myColor: Colors.redAccent);
      // to delete dialog page
    }
  }

  uploadComment(
      {required context, required commentController, required postId}) async {
    final userData = Provider.of<UserProvider>(context, listen: false).getUser;
    String commentId = const Uuid().v1();
    await FirebaseFirestore.instance
        .collection("postss")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .set({
      "username": userData!.userName,
      "comment": commentController.text,
      "datePublished": DateTime.now(),
      "ProfilePicture": userData.ProfileImage,
      "uid": userData.uid,
      "commentId": commentId,
    });

    toastMessag(msg: 'comment added', myColor: Colors.greenAccent);
  }

  clickLikeOrNot({required List likes, required String postId}) async {
    if (likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance.collection("postss").doc(postId).update(
        {
          "likes": FieldValue.arrayRemove(
            [FirebaseAuth.instance.currentUser!.uid],
          ),
        },
      );
    } else {
      await FirebaseFirestore.instance.collection("postss").doc(postId).update(
        {
          "likes": FieldValue.arrayUnion(
            [FirebaseAuth.instance.currentUser!.uid],
          ),
        },
      );
    }
  }
}
