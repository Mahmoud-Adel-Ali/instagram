import 'package:flutter/material.dart';
import 'package:instagram/constant/colors.dart';

class Favorit extends StatefulWidget {
  const Favorit({super.key});

  @override
  State<Favorit> createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
          // screenWidth >= 600 ? webBackgroundColor : mobileBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            screenWidth >= 600 ? webBackgroundColor : mobileBackgroundColor,
        title: const Text(
          "favorit",
          style: TextStyle(color: Colors.white),
        ),
      ),
        body: 
        Center(
        child: Container(
          
          width: screenWidth/2,
          decoration: BoxDecoration(
            color: Colors.black,
                borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    
    );
  }
}
