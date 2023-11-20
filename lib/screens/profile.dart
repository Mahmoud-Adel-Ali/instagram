// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constant/colors.dart';
import 'package:instagram/shared/toastMessag.dart';

class Profile extends StatefulWidget {
  final String uidd;
  const Profile({Key? key, required this.uidd}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map userDate = {};
  bool isLoading = true;
  int followers = 0;
  int following = 0;
  int numOfPosts = 0;
  bool follow = false;
  getData() async {
    // Get data from DB
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('userss')
          .doc(widget.uidd)
          .get();

      userDate = snapshot.data()!;
      //------------------------------------
      var snapShotPosts = await FirebaseFirestore.instance
          .collection('postss')
          .where("uid", isEqualTo: widget.uidd)
          .get();
      numOfPosts = snapShotPosts.docs.length;
      followers = userDate["Followers"].length;
      following = userDate["Following"].length;
      follow = userDate['Followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      toastMessag(msg: e.toString(), myColor: Colors.red);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return isLoading
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userDate["userName"]),
            ),
            body: Center(
              child: SizedBox(
                width:
                    widthScreen >= 600 ? 2 * widthScreen / 3 : double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 22),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(125, 78, 91, 110),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(userDate["ProfileImg"].toString()),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    numOfPosts.toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Posts",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(width: 17),
                              Column(
                                children: [
                                  Text(
                                    followers.toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(width: 17),
                              Column(
                                children: [
                                  Text(
                                    following.toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(33, 21, 0, 0),
                        width: double.infinity,
                        child: Text(userDate["jop"].toString())),
                    SizedBox(height: 15),
                    Divider(
                      color: Colors.white,
                      thickness: widthScreen > 600 ? 0.06 : 0.43,
                    ),
                    SizedBox(height: 9),
                    //--------------------------------------
                    (widget.uidd == FirebaseAuth.instance.currentUser!.uid)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 24.0,
                                ),
                                label: Text(
                                  "Edit profile",
                                  style: TextStyle(fontSize: 17),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(0, 90, 103, 223)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: widthScreen > 600 ? 19 : 10,
                                          horizontal: 33)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              109, 255, 255, 255),
                                          // width: 1,
                                          style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.logout,
                                  size: 24.0,
                                ),
                                label: Text(
                                  "Log out",
                                  style: TextStyle(fontSize: 17),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(143, 255, 55, 112)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: widthScreen > 600 ? 19 : 10,
                                          horizontal: 33)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : (follow)
                            //unfollow
                            ? ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    followers--;
                                    follow = false;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("userss")
                                      .doc(widget.uidd)
                                      .update({
                                    "Followers": FieldValue.arrayRemove([
                                      FirebaseAuth.instance.currentUser!.uid
                                    ])
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("userss")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    "Following":
                                        FieldValue.arrayRemove([widget.uidd])
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: widthScreen > 600 ? 19 : 10,
                                          horizontal: 33)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              109, 255, 255, 255),
                                          // width: 1,
                                          style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "UnFollow",
                                  style: TextStyle(fontSize: 17),
                                ),
                              )
                            //follow
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    followers++;
                                    follow = true;
                                  });
                                  //To add value  into a list
                                  await FirebaseFirestore.instance
                                      .collection("userss")
                                      .doc(widget.uidd)
                                      .update({
                                    "Followers": FieldValue.arrayUnion([
                                      FirebaseAuth.instance.currentUser!.uid
                                    ])
                                  });

                                  await FirebaseFirestore.instance
                                      .collection("userss")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    "Following":
                                        FieldValue.arrayUnion([widget.uidd])
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: widthScreen > 600 ? 19 : 10,
                                          horizontal: 33)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              109, 255, 255, 255),
                                          // width: 1,
                                          style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  " Follow ",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),

                    //-----------------------------------------
                    SizedBox(height: 9),
                    Divider(
                      color: Colors.white,
                      thickness: widthScreen > 600 ? 0.06 : 0.43,
                    ),
                    SizedBox(height: 19),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('postss')
                          .where("uid", isEqualTo: widget.uidd)
                          .get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return Expanded(
                            child: Padding(
                              padding: widthScreen > 600
                                  ? const EdgeInsets.all(66.0)
                                  : const EdgeInsets.all(3.0),
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        // snapshot.data!.docs  = [  {"imgPost": 000000000}, {"imgPost": 0000000}    ]
                                        snapshot.data!.docs[index]["imgPost"],
                                        loadingBuilder:
                                            (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                  color: Colors.white,
                                                ));
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }),
                            ),
                          );
                        }

                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
