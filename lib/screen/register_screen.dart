import 'package:flutter/material.dart';
import 'package:ojek/common/variable.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/screen/login_screen.dart';
import 'package:ojek/screen/theme.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String? role = '';
  final nama = TextEditingController();
  final hp = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confPassword = TextEditingController();
  final plat = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showMyDialogSuccess() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: Color(0xFFFCCCBC),
                ),
                Container(
                  height: 15,
                ),
                Text(
                  'Success!!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 15,
                ),
                Text(
                  'Selamat kamu berhasil daftar sebagai $role',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: flatButtonStyle,
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> register() async {
    var param = {
      "name": nama.text,
      "email": email.text,
      "password": password.text,
      "password_confirmation": confPassword.text,
      "phone": hp.text,
      "role": role,
    };

    if (role == "driver") {
      param.addAll({"nomor_kendaraan": plat.text});
    }

    print(param);

    Provider.of<Register>(context, listen: false)
        .registerFunc(param)
        .then((value) {
      if (value.status == 201) {
        _showMyDialogSuccess();
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
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nama,
                      decoration: InputDecoration(
                        labelText: "Nama",
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                      controller: hp,
                      decoration: InputDecoration(
                        labelText: "No HP",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
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
                    TextFormField(
                      controller: confPassword,
                      decoration: InputDecoration(
                        labelText: "Konfirmasi Password",
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                    ),
                    role == "driver"
                        ? TextFormField(
                            controller: plat,
                            decoration: InputDecoration(
                              labelText: "Plat Nomor",
                            ),
                            keyboardType: TextInputType.name,
                          )
                        : Container(),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        'Daftar Sebagai :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                value: "driver",
                                activeColor: secondaryColor,
                                groupValue: role,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    role = newValue;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text("Driver"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                value: "penumpang",
                                activeColor: secondaryColor,
                                groupValue: role,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    role = newValue;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text("Penumpang"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () {
                          if (role == "") {
                            final snackbar = SnackBar(
                              content: Text(
                                  "Mohon untuk memilih driver atau penumpang"),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else {
                            register();
                          }
                        },
                        color: secondaryColor,
                        textColor: Colors.white,
                        child: Text('Daftar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
