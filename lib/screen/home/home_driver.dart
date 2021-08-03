import 'package:flutter/material.dart';
import 'package:ojek/common/variable.dart';
import 'package:ojek/model/appModel.dart';
import 'package:provider/provider.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/typicons_icons.dart';

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({Key? key}) : super(key: key);

  @override
  _HomeDriverScreenState createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    minimumSize: Size(88, 44),
    // padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    backgroundColor: primaryColor,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            // color: Colors.red,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  width: double.infinity,
                  height: 250,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: primaryColor.withOpacity(0.40),
                        ),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_location_alt,
                                color: Colors.grey[400],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Tambahkan lokasi kamu",
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 52,
                          padding: EdgeInsets.all(8),
                          child: TextButton(
                            onPressed: () {},
                            style: flatButtonStyle,
                            child: Text("PILIH DESTINASI",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageIcon(
                        AssetImage(
                            'assets/images/healthicons_truck-driver.png'),
                        size: 60,
                        color: Colors.black45,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 17, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, Driver",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontSize: 17),
                            ),
                            Text(
                              "driver",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              size: 30,
                              color: Colors.black45,
                            ),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 15),
            child: Text(
              "Order Masuk :",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF616161)),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(5, 3),
                  blurRadius: 3,
                  color: primaryColor.withOpacity(0.18),
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle_rounded,
                        size: 50,
                        color: Colors.black45.withOpacity(0.12),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                width: 150,
                                child: Text(
                                  "Nama Penumpang",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                "Alamat Penjemputan",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                            Container(
                              width: 8,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: primaryColor,
                              size: 40,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
