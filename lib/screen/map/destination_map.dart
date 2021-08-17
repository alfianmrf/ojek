import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ojek/model/searc_map.dart';
import 'package:ojek/screen/theme.dart';
import 'package:provider/provider.dart';

class DestinationMappScreen extends StatefulWidget {
  DestinationMappScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _DestinationMappScreenState createState() => _DestinationMappScreenState();
}

class _DestinationMappScreenState extends State<DestinationMappScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng currentPostion;
  TextEditingController alamat = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<Marker> _markers = [];
  late String address;
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

  _getDestinationLocation() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _markers[0].position.latitude, _markers[0].position.longitude);
    address =
        "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].postalCode}";
    // print(address);
    alamat.text = address;
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
          'Pilih Destinasi',
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
              markers: _markers.toSet(),
              onMapCreated: (controller) {
                final marker = Marker(
                  markerId: MarkerId('0'),
                  position:
                      LatLng(currentPostion.latitude, currentPostion.longitude),
                );

                _markers.add(marker);
              },
              onCameraMove: (position) {
                setState(() {
                  _markers.first =
                      _markers.first.copyWith(positionParam: position.target);
                  // _getDestinationLocation();
                  // print(_markers[0].position.longitude);
                });
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
                          hintText: "Jl. Ahmad yani no 89",
                          fillColor: Colors.white70),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        _getDestinationLocation();
                      },
                      child: Text("Ambil Lokasi"),
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
