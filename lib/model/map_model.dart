import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojek/model/model.dart';
import 'package:ojek/utils/globalURL.dart';

class MapModel with ChangeNotifier {
  late double pickupLat = 0;
  late double pickupLong = 0;
  late double destinationLat = 0;
  late double destinationLong = 0;

  Future<MessageResult> searchDriver(String token,String address) async {
    print(token);
    var result =
        MessageResult(status: 500, message: "Maaf terjadi kesalahan server");
    var param = <String, dynamic>{
      "pickup_lat": pickupLat,
      "pickup_long": pickupLong,
      "destination_lat": destinationLat,
      "destination_long": destinationLong,
      "fee": 8000,
      "destination_address": address
    };

    var res = await http.post(
      Uri.parse(searchDriverURL),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: json.encode(param),
    );

    print(json.encode(res.body));

    if (res.statusCode == 201) {
      result = MessageResult(status: res.statusCode, message: "Berhasil");
      notifyListeners();
      return result;
    }
    notifyListeners();
    return result;
  }
}
