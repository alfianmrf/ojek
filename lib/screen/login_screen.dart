import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ojek/common/variable.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/screen/home/home_user.dart';
import 'package:ojek/screen/register_screen.dart';
import 'package:provider/provider.dart';

import 'home/home_driver.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  void setLoginAuth() async {
    var param = {"email": email.text, "password": password.text};

    Provider.of<AppModel>(context, listen: false)
        .setAuth(param)
        .then((value) async {
      print(value.message);
      if (value.status == 200) {
        if (value.role == "user") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeUserScreen(),
            ),
          );
        } else if (value.role == "driver") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeDriverScreen(),
            ),
          );
        }
      } else {
        final snackbar = SnackBar(
          content: Text(value.message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      backgroundColor: primaryColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Image.network(
                    "https://shejek.id/assets/img/core-img/logo-small.png",
                    fit: BoxFit.contain,
                    width: 150,
                  ),
                ),
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          child: MaterialButton(
                            onPressed: () {
                              setLoginAuth();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => HomeUserScreen(),
                              //   ),
                              // );
                            },
                            color: secondaryColor,
                            textColor: Colors.white,
                            child: Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tidak mempunyai akun ? ',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                        child: Text(
                          'Daftar Disini',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
