


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastMessag({required String msg, required Color myColor}) {
  // one second for 4
  int time = 1;
  for (var i = 0; i < msg.length; i += 4) {
    time++;
  }
  return Fluttertoast.showToast(
      msg: msg, // text
      backgroundColor: myColor, // color
      fontSize: 20.0, // text size
      timeInSecForIosWeb: time, 
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM_RIGHT);// position of messag
}
