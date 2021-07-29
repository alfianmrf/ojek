import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ojek/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  removeScreen() {
    return _timer = Timer(Duration(seconds: 2), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      removeScreen();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.network(
          "https://shejek.id/assets/img/core-img/logo-small.png",
          fit: BoxFit.contain,
          width: 200,
        ),
      ),
    );
  }
}
