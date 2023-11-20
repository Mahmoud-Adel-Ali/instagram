// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final String profileImg;
  final String userName;
  final String description;
  final String imgPost;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final List likes;

  PostData({
    required this.profileImg,
    required this.userName,
    required this.description,
    required this.imgPost,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.likes,
  });
  Map<String, dynamic> convert2Map() {
    return {
      "profileImg": profileImg,
      "userName": userName,
      "description": description,
      "imgPost": imgPost,
      "uid": uid,
      "postId": postId,
      "datePublished": datePublished,
      "likes": likes,
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostData(
      profileImg: snapshot["profileImg"],
      userName: snapshot["userName"],
      description: snapshot["description"],
      imgPost: snapshot["imgPost"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      likes: snapshot["likes"],
    );
  }
}
