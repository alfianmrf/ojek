import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ojek/common/variable.dart';
import 'package:ojek/model/driver_map_model.dart';
import 'package:ojek/model/model.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../theme.dart';

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({Key? key}) : super(key: key);

  @override
  _HomeDriverScreenState createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng currentPostion;
  int index = 1;
  final List<Marker> _markers = [];
  List<Marker> list = [];

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
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var auth =
          Provider.of<AppModel>(context, listen: false).auth!.accessToken;
      Provider.of<DriverModel>(context, listen: false)
          .getListPenumpang(auth)
          .then((value) {
        if (value.status == 200) {
          _getUserLocation();
        }
      });
    });
  }

  void _terimaPesanan(int orderId) async {
    var auth = Provider.of<AppModel>(context, listen: false).auth!.accessToken;
    Provider.of<DriverModel>(context, listen: false).acceptOrder(auth, orderId);
  }

  void _getPenumpangByIndex() async {
    _markers.clear();
    var penumpang =
        Provider.of<DriverModel>(context, listen: false).listPenumpang[index];
    setState(() {
      list = [
        Marker(
          markerId: MarkerId('Lokasi Penumpang'),
          position: LatLng(double.parse(penumpang.pickupLat),
              double.parse(penumpang.pickupLong)),
          infoWindow: InfoWindow(title: 'Lokasi Penumpang'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        Marker(
          markerId: MarkerId('Destinasi'),
          position: LatLng(
            double.parse(penumpang.destinationLat),
            double.parse(penumpang.destinationLong),
          ),
          infoWindow: InfoWindow(title: 'Destinasi'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        )
      ];
      _markers.addAll(list);
    });
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DriverModel>(
        builder: (context, value, child) {
          return SingleChildScrollView(
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
                          padding: EdgeInsets.only(top: 20),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(14, 10, 14, 14),
                                child: Text(
                                  "Penghasilan :",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(14, 0, 14, 14),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Hari Ini : Rp. 1.000.000",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(
                                            "Bulan Ini : Rp. 1.000.000",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      width: 1,
                                      color: Colors.black38,
                                      height: 30,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Hari ini :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(
                                            "6 Penumpang",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 70, horizontal: 20),
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
                                    Provider.of<AppModel>(context).auth!.name,
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
                                  GestureDetector(
                                    onTap: () {
                                      _showMyDialogLogOut();
                                    },
                                    child: Text(
                                      "Log Out",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: value.listPenumpang.length,
                        itemBuilder: (BuildContext context, int i) {
                          return GestureDetector(
                            onTap: () {
                              index = i;
                              _getPenumpangByIndex();
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(14, 10, 14, 10),
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
                                          color:
                                              Colors.black45.withOpacity(0.12),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: Container(
                                                  width: 150,
                                                  child: Text(
                                                    "Nama Penumpang",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                              GestureDetector(
                                                onTap: () {
                                                  _terimaPesanan(value
                                                      .listPenumpang[i].id);
                                                },
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: primaryColor,
                                                  size: 40,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 400,
                        margin: EdgeInsets.only(
                            bottom: 200, left: 14, right: 14, top: 10),
                        child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: currentPostion,
                            zoom: 16,
                          ),
                          markers: _markers.toSet(),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
