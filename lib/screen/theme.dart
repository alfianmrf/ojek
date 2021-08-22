import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ojek/main.dart';
import 'package:flutter/material.dart';

Color accentColor = Color(0xFFFCCCBC);

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
final ButtonStyle borderButtonStylePrimary = TextButton.styleFrom(
  primary: Colors.black45,
  minimumSize: Size(88, 44),
  shape: const RoundedRectangleBorder(
    side: BorderSide(color: Color(0xFF5EE1F1), width: 1),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

final spinkit = SpinKitFadingCube(
  color: Color(0xFFFCCCBC),
  size: 50.0,
);
final spinkitWht = SpinKitFadingCube(
  color: Colors.white,
  size: 50.0,
);
final spinkitblue = SpinKitFadingCube(
  color: Colors.white,
  size: 50.0,
);
