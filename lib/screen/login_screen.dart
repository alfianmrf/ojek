import 'package:flutter/material.dart';
import 'package:ojek/common/variable.dart';
import 'package:ojek/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          child: MaterialButton(
                            onPressed: (){},
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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
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
