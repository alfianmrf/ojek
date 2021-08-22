import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:ojek/model/map_model.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/model/user_model.dart';
import 'package:ojek/screen/map/destination_map.dart';
import 'package:ojek/screen/map/user_map.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../theme.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({Key? key}) : super(key: key);

  @override
  _HomeUserScreenState createState() => _HomeUserScreenState();
}

String address = "";
int? id;

class _HomeUserScreenState extends State<HomeUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final formatCurrency =
      NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      var data = event.notification.additionalData;
      print("hommeee");
      if (data!['role'] == "penumpang") {
        _getInfoDriver();
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
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _getInfoDriver();
    });
  }

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
    setState(() {
      id = 0;
    });
  }

  void _getInfoDriver() async {
    var auth = Provider.of<AppModel>(context, listen: false).auth!.accessToken;
    Provider.of<UserModel>(context, listen: false).infoDriver(auth);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    var auth = Provider.of<AppModel>(context, listen: false).auth!.accessToken;
    Provider.of<UserModel>(context, listen: false)
        .infoDriver(auth)
        .then((value) {
      _getInfoDriver();
      _refreshController.refreshCompleted();
    });
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Widget build(BuildContext context) {
    var user = Provider.of<AppModel>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: accentColor,
        key: _formKey,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("pull up load");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("release to load more");
              } else {
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Consumer<UserModel>(
            builder: (context, value, child) {
              return value.isLoading
                  ? spinkitWht
                  : Container(
                      color: Colors.white,
                      child: Column(
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 7,
                                          color: Color(0xFFFCCCBC)
                                              .withOpacity(0.40),
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
                                            border: Border.all(
                                                color: Color(0xFFFCCCBC),
                                                width: 1),
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
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  width: 200,
                                                  child: Text(
                                                      address != ""
                                                          ? "$address"
                                                          : "Tambahkan lokasi kamu",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[400]),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserLocationScreen(),
                                                ),
                                              ).then(getBackAddress);
                                            },
                                            style: flatButtonStyle,
                                            child: Text("PILIH DESTINASI",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 70, horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.account_circle_rounded,
                                        size: 70,
                                        color: Colors.black45.withOpacity(0.12),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 17, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  color: Colors.black45,
                                                  fontSize: 12),
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
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 17, 0, 0),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                          value.isDriverFound != true
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(top: 20, left: 15),
                                  child: Text(
                                    "Detail Perjalanan",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF616161)),
                                  ),
                                ),
                          value.isDriverFound != true
                              ? Center(
                                  child: Container(
                                  margin: EdgeInsets.only(top: 30),
                                  padding: EdgeInsets.fromLTRB(90, 14, 90, 14),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/notfound.png',
                                      ),
                                      Text(
                                        "Tidak ada pesanan",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 20),
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(5, 3),
                                        blurRadius: 7,
                                        color:
                                            Color(0xFFFCCCBC).withOpacity(0.30),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            user.auth!.name,
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Total : ${formatCurrency.format(value.infoDriverUser!.fee)}",
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
                                                child: Image.asset(
                                                    'assets/images/logoNoBackground.png')),
                                          ),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Container(
                                                    width: 230,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Nama Driver : ",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          value.infoDriverUser!
                                                              .name!,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Plat Nomor : ",
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        value.infoDriverUser!
                                                            .nomorKendaraan!,
                                                        style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Container(
                                                    width: 230,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "No HP : ",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          "Jawa Timur Park",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black45,
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
            },
          ),
        ),
      ),
    );
  }
}
