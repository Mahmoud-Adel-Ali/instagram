// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String userName;
  String password;
  String jop;
  String emailAddress;
  String ProfileImage;
  String uid;
  List followers = [];
  List following = [];

  UserData({
    required this.userName,
    required this.jop,
    required this.emailAddress,
    required this.password,
    required this.ProfileImage,
    required this.uid,
    required this.followers,
    required this.following,
  });

  // convert UserData class to Map<String,dynamic
  Map<String, dynamic> Convert2Map() {
    return {
      "userName": userName,
      "jop": jop,
      "password": password,
      "email": emailAddress,
      "ProfileImage": ProfileImage,
      "uid": uid,
      "Followers": followers,
      "Following": following,
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      emailAddress: snapshot["email"],
      password: snapshot["password"],
      userName: snapshot["userName"],
      jop: snapshot["jop"],
      followers: snapshot["Followers"],
      following: snapshot["Following"],
      ProfileImage: snapshot["ProfileImage"],
      uid: snapshot["uid"],
    );
  }
}
