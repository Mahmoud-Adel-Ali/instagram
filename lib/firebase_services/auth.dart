// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/firebase_services/storage.dart';
import 'package:instagram/models/userData.dart';
import 'package:instagram/screens/signIn.dart';
import 'package:instagram/responsive/mobileScreen.dart';
import 'package:instagram/responsive/responsive.dart';
import 'package:instagram/responsive/webScreen.dart';
import 'package:instagram/shared/toastMessag.dart';

class AuthClass {
  final context;
  AuthClass({required this.context});

  register({
    required emailAddress,
    required password,
    required userName,
    required jop,
    required imgName,
    required imgPath,
  }) async {
    showDialog(
        context: context,
        builder: (BackButton) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    String messag = "Erorr : not registered";
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress.text,
        password: password.text,
      );
      messag = "user register to firebase";
      CollectionReference users =
          FirebaseFirestore.instance.collection("userss");
      // ("userss") name of collection in firebase firestor
      //----------------------------------------
      String url = await getImgUrl(
          imgName: imgName, imgPath: imgPath, folderName: 'profileImages');
      //----------------------------------------
      //variable from UserData
      UserData userData = UserData(
        userName: userName.text,
        jop: jop.text,
        emailAddress: emailAddress.text,
        password: password.text,
        ProfileImage: url,
        uid: credential.user!.uid,
        followers: [],
        following: [],
      );
      // add details of use to firebase firestor
      users
          .doc(credential.user?.uid)
          .set(userData.Convert2Map())
          .then((value) =>
              toastMessag(msg: "user added", myColor: Colors.redAccent))
          .catchError((error) => toastMessag(
              msg: "Faild to add user : $error .", myColor: Colors.redAccent));
      messag = "user register to firebase & Database ♥";

      // showSnackBar(context, "Done....");
      Navigator.pop(context); // to delete dialog page

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => const SignIn()),
        ),
      );
    } on FirebaseAuthException catch (e) {
      toastMessag(msg: e.toString(), myColor: Colors.redAccent);

      Navigator.pop(context); // to delete dialog page
    } catch (e) {
      toastMessag(msg: e.toString(), myColor: Colors.redAccent);

      Navigator.pop(context); // to delete dialog page
    }
  }

  signIn({required emailAddress, required password}) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      // showSnackBar(context, "waite to verify your email");
      
      toastMessag(msg: 'Done..', myColor: Colors.greenAccent);

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => const Responsive(
                myWebScreen: WebScreen(),
                myMobileScreen: MobileScreen(),
              )),
        ),
      );
    } on FirebaseAuthException catch (e) {
      toastMessag(msg: e.toString(), myColor: Colors.redAccent);

      Navigator.pop(context);
    }
    // Stop indicator
    // if (!mounted) return;
    // Navigator.pop(context);
  }

  // functoin to get user details from Firestore (Database)
  Future<UserData> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('userss')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserData.convertSnap2Model(snap);
  }
}
