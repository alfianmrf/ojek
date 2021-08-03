import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/screen/home/home_user.dart';
import 'package:ojek/screen/login_screen.dart';
import 'package:provider/provider.dart';

import 'home/home_driver.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  removeScreen() {
    return _timer = Timer(Duration(seconds: 2), () async {
      print(Provider.of<AppModel>(context, listen: false).logedIn);
      Provider.of<AppModel>(context, listen: false).logedIn
          ? Provider.of<AppModel>(context, listen: false).auth!.role == "user"
              ? Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => HomeUserScreen(),
                  ))
              : Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) => HomeDriverScreen(),
                  ))
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Provider.of<AppModel>(context, listen: false).getAuth();
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
