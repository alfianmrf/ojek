import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojek/model/get_order.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/utils/globalURL.dart';

class MapModel with ChangeNotifier {
  late double pickupLat = 0;
  late double pickupLong = 0;
  late double destinationLat = 0;
  late double destinationLong = 0;

  Future<GetOrderUser?> searchDriver(String token, String address) async {
    print(token);
    GetOrderUser? result;
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
    print(res.statusCode);
    print(json.encode(res.body));
    var decode = json.decode(res.body);

    if (res.statusCode == 200) {
      result = GetOrderUser.fromJson(decode);
      print(result);
      notifyListeners();
      return result;
    }
    notifyListeners();
    return result;
  }
}
