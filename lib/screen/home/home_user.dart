import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/screen/map/user_map.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({Key? key}) : super(key: key);

  @override
  _HomeUserScreenState createState() => _HomeUserScreenState();
}

String address = "";

class _HomeUserScreenState extends State<HomeUserScreen> {
  Future<void> _showMyDialogLogOut() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Apakah Kamu Ingin Keluar ?',
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  // width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.symmetric(horizontal: 30),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Tidak",
                    ),
                    style: flatButtonStyle,
                  ),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  // width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.symmetric(horizontal: 30),
                  child: TextButton(
                    onPressed: () {
                      Provider.of<AppModel>(context, listen: false)
                          .logout()
                          .then((value) {
                        Phoenix.rebirth(context);
                      });
                    },
                    child: Text(
                      "Iya",
                      style: TextStyle(
                        color: Color(0xFFFCCCBC),
                      ),
                    ),
                    style: borderButtonStyle,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  getBackAddress(dynamic value) {
    setState(() {});
  }

  Widget build(BuildContext context) {
    var user = Provider.of<AppModel>(context);
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
                    color: Color(0xFFFCCCBC),
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
                          color: Color(0xFFFCCCBC).withOpacity(0.40),
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
                            border:
                                Border.all(color: Color(0xFFFCCCBC), width: 1),
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserLocationScreen(),
                                    ),
                                  ).then(getBackAddress);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: 200,
                                  child: Text(
                                      address != ""
                                          ? "$address"
                                          : "Tambahkan lokasi kamu",
                                      style: TextStyle(color: Colors.grey[400]),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false),
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
                      Icon(
                        Icons.account_circle_rounded,
                        size: 70,
                        color: Colors.black45.withOpacity(0.12),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 17, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, Customer",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontSize: 17),
                            ),
                            Text(
                              user.auth!.name,
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _showMyDialogLogOut();
                        },
                        child: Padding(
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
              "Detail Perjalanan",
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
                  blurRadius: 7,
                  color: Color(0xFFFCCCBC).withOpacity(0.30),
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nama Customer",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total : Rp 50.000",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black.withOpacity(0.24),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=750&q=80",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              width: 230,
                              child: Row(
                                children: [
                                  Text(
                                    "Nama Driver : ",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Jhon Doe",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Text(
                                  "Plat Nomor : ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "L 27312 BK",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              width: 230,
                              child: Row(
                                children: [
                                  Text(
                                    "Alamat Tujuan : ",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Jawa Timur Park",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => HomeDriverScreen(),
                          //       ),
                          //     );
                          //   },
                          //   child: Text("driver"),
                          //   style: flatButtonStyle,
                          // )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
