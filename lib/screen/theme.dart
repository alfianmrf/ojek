import 'package:ojek/main.dart';
import 'package:flutter/material.dart';

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.white,
  minimumSize: Size(88, 44),
  // padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  backgroundColor: Color(0xFFFCCCBC),
);

final ButtonStyle borderButtonStyle = TextButton.styleFrom(
  primary: Colors.black45,
  minimumSize: Size(88, 44),
  shape: const RoundedRectangleBorder(
    side: BorderSide(color: Color(0xFFFCCCBC), width: 1),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
