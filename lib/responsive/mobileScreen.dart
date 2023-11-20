
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/constant/colors.dart';
import 'package:instagram/screens/add_post.dart';
import 'package:instagram/screens/favorit.dart';
import 'package:instagram/screens/home.dart';
import 'package:instagram/screens/profile.dart';
import 'package:instagram/screens/search.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final PageController _pageController = PageController();
  int pageIndex = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            pageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: pageIndex == 0 ? primaryColor : secondaryColor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: pageIndex == 1 ? primaryColor : secondaryColor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              size: 40,
              color: pageIndex == 2 ? primaryColor : secondaryColor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: pageIndex == 3 ? primaryColor : secondaryColor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: pageIndex == 4 ? primaryColor : secondaryColor,
            ),
            label: "",
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (index) {},
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          const Home(),
          const Search(),
          const AddPost(),
          const Favorit(),
          Profile(uidd: FirebaseAuth.instance.currentUser!.uid,),
        ],
      ),
    );
  }
}
