import 'package:flutter/material.dart';
import 'package:ojek/common/variable.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? role = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      decoration: InputDecoration(
                        labelText: "Nama",
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "No HP",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Konfirmasi Password",
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                    ),
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
                                value: "customer",
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
                        onPressed: (){},
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
