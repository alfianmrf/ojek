import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ojek/common/variable.dart';
import 'package:ojek/model/map_model.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/screen/home/home_user.dart';
import 'package:ojek/screen/order/user_order_screen.dart';
import 'package:ojek/screen/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({Key? key}) : super(key: key);

  @override
  _UserLocationScreenState createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng currentPostion;
  final _formKey = GlobalKey<FormState>();
  final List<Marker> _markers = [];
  bool isLoading = true;

  TextEditingController alamatUser = TextEditingController();
  TextEditingController alamatDestinasi = TextEditingController();

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
      isLoading = false;
    });
  }

  _getCurrentLocation() async {
    var pickup = Provider.of<MapModel>(context, listen: false);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPostion.latitude, currentPostion.longitude);
    address =
        "${placemarks[0].street} , ${placemarks[0].locality}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].postalCode}";
    alamatUser.text = address;
    pickup.pickupLat = currentPostion.latitude;
    pickup.pickupLong = currentPostion.longitude;
    _getDestinationLocation();
  }

  _getDestinationLocation() async {
    var pickup = Provider.of<MapModel>(context, listen: false);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _markers[0].position.latitude, _markers[0].position.longitude);
    address =
        "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].postalCode}";
    pickup.destinationLat = _markers[0].position.latitude;
    pickup.destinationLong = _markers[0].position.longitude;
    alamatDestinasi.text = address;
  }

  Future<void> cariDriver() async {
    Provider.of<MapModel>(context, listen: false)
        .searchDriver(
            Provider.of<AppModel>(context, listen: false).auth!.accessToken,
            alamatDestinasi.text)
        .then((value) {
      if (value.status == 201) {
        print("berhasil");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserOrderScreen(),
          ),
        );
      } else {
        final snackbar = SnackBar(
          content: Text(value.message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

  void _getDistance() async {
    var res = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C,-73.9976592&key=AIzaSyAvEY0wfdWGDfxEfXHjC8O0EyWVSzTqd9w"),
    );
    print(json.encode(res.body));
  }

  Widget build(BuildContext context) {
    var userMap = Provider.of<MapModel>(context);
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
      body: isLoading
          ? spinkit
          : Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 200),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: currentPostion,
                      zoom: 16,
                    ),
                    markers: _markers.toSet(),
                    onMapCreated: (controller) {
                      final marker = Marker(
                        markerId: MarkerId('0'),
                        position: LatLng(
                            currentPostion.latitude, currentPostion.longitude),
                      );

                      _markers.add(marker);
                    },
                    onCameraMove: (position) {
                      setState(() {
                        _markers.first = _markers.first
                            .copyWith(positionParam: position.target);
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lokasi Anda",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 10, top: 5),
                          child: TextField(
                            controller: alamatUser,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 5, left: 12),
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
                        Text(
                          "Destinasi",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 10, top: 5),
                          child: TextField(
                            controller: alamatDestinasi,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 5, left: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                hintText: "Jl. Ahmad Yani No 90",
                                fillColor: Colors.white70),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                height: 40,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _getDistance();
                                      _getCurrentLocation();
                                    });
                                  },
                                  child: Text("Proses"),
                                  style: flatButtonStyle,
                                ),
                              ),
                            ),
                            alamatUser.text.length != 0
                                ? Container(
                                    width: 10,
                                  )
                                : Container(),
                            alamatUser.text.length != 0
                                ? Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      height: 40,
                                      child: TextButton(
                                        onPressed: () {
                                          cariDriver();
                                        },
                                        child: Text(
                                          "Cari Driver",
                                          style: TextStyle(
                                              color: Color(0xFFFCCCBC)),
                                        ),
                                        style: borderButtonStyle,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
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
