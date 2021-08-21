import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ojek/common/variable.dart';
import 'package:ojek/model/driver_map_model.dart';
import 'package:ojek/model/map_model.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/model/user_model.dart';
import 'package:ojek/screen/home/home_user.dart';
import 'package:ojek/screen/theme.dart';
import 'package:ojek/utils/globalURL.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserOrderScreen extends StatefulWidget {
  const UserOrderScreen({Key? key}) : super(key: key);

  @override
  _UserOrderScreenState createState() => _UserOrderScreenState();
}

class _UserOrderScreenState extends State<UserOrderScreen> {
  @override
  void initState() {
    super.initState();
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print("keluaar waktu notif muncul");
      print(event.notification.body);
      // print(event.notification.additionalData);
      var data = event.notification.additionalData;
      if (data!['role'] ==
          Provider.of<AppModel>(context, listen: false).auth!.role) {
        _getInfoDriver();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeUserScreen()));
      }

      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("ketika di klik");
      // Will be called whenever a notification is opened/button pressed.
    });
  }

  void _cancelOrder() async {
    var auth = Provider.of<AppModel>(context, listen: false).auth!.accessToken;
    Provider.of<DriverModel>(context, listen: false)
        .cancelOrder(id!, auth, true)
        .then((value) {
      if (value == true) {
        Navigator.pop(context);
        _getInfoDriver();
        _sendNotifToDriver(
            Provider.of<MapModel>(context, listen: false).uuidDriver!);
      }
    });
  }

  void _getInfoDriver() async {
    var auth = Provider.of<AppModel>(context, listen: false).auth!.accessToken;
    Provider.of<UserModel>(context, listen: false).infoDriver(auth);
  }

  void _sendNotifToDriver(List<String> uuid) async {
    var param = <String, dynamic>{
      "app_id": "302fc91f-1847-4650-9a8d-40d872fee45d",
      "include_player_ids": uuid,
      "data": {"role": "driver", "action": "batal"},
      "contents": {"en": "User membatalkan pesanan"}
    };
    print(json.encode(param));
    var token = "MGM3NDZmMDUtM2U2ZS00YTY4LThlM2MtMmYzZGIyZDc2NDky";
    var res = await http.post(Uri.parse(sendNotificationOrderURL),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: json.encode(param));
    print(json.decode(res.body));
    Provider.of<MapModel>(context).uuidDriver = [];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logoNoBackground.png',
              fit: BoxFit.contain,
              width: 170,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      "Sedang Mencari Driver...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    child: Text(
                      "Mohon tunggu, kami sedang mencarikan driver untuk kamu.",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height: 12,
                  ),
                  TextButton(
                    style: borderButtonStyle,
                    onPressed: () {
                      _cancelOrder();
                    },
                    child: Text(
                      "Batalkan",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFCCCBC),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
