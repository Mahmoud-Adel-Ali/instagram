

import 'package:flutter/material.dart';

const decorationTextfield = InputDecoration(
  fillColor: Colors.white,
  // To delete borders
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 3,
      color: Color.fromARGB(255, 0, 177, 18),
    ),
  ),
  // fillColor: Colors.red,
  filled: true,
  contentPadding: EdgeInsets.all(5),
  
);