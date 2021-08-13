import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ojek/screen/home/home_user.dart';
import 'package:ojek/screen/theme.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({Key? key}) : super(key: key);

  @override
  _UserLocationScreenState createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng currentPostion;
  TextEditingController alamat = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  _getCurrentLocation() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPostion.latitude, currentPostion.longitude);
    address =
        "${placemarks[0].thoroughfare} (${alamat.text}), ${placemarks[0].locality}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].postalCode}";
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.18),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 18,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Pilih Lokasi',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 130),
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: currentPostion,
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: alamat,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          hintText: "Tambahkan No. Rumah, RT, RW",
                          fillColor: Colors.white70),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        if (alamat.text == "") {
                          final snackbar = SnackBar(
                            content: Text("Maaf, isi no alamat ya? :("),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          _getCurrentLocation();
                        }
                      },
                      child: Text("Ambil Lokasi Saat ini"),
                      style: flatButtonStyle,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
