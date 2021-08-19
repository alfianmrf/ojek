import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojek/model/model.dart';
import 'package:ojek/utils/globalURL.dart';

class DriverModel with ChangeNotifier {
  late List<ListPenumpang> listPenumpang = [];

  Future<MessageResult> getListPenumpang(String token) async {
    var message =
        MessageResult(status: 500, message: "Maaf, ada Kesalahan Server");
    var res = await http.get(Uri.parse(listPenumpangURL), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    // print(res.body);
    var decode = json.decode(res.body);
    if (res.statusCode == 200) {
      // listPenumpang = res.body as ListPenumpang;
      for (var item in decode) {
        listPenumpang.add(ListPenumpang.fromJson(item));
      }
      message = MessageResult(status: 200, message: "Berhasil");
      notifyListeners();
      return message;
    }
    notifyListeners();
    return message;
  }

  Future<bool> acceptOrder(String token, int orderId) async {
    var param = <String, dynamic>{'order_id': orderId};
    var res = await http.post(Uri.parse(ordereAcceptURL),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: json.encode(param));
    if (res.statusCode == 200) {
      getListPenumpang(token);
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }
}

class ListPenumpang {
  late int id;
  late int customerId;
  late String pickupLat;
  late String pickupLong;
  late String destinationLat;
  late String destinationLong;
  late int fee;
  late String status;
  late String createdAt;
  late String updatedAt;

  ListPenumpang(
      {required this.id,
      required this.customerId,
      required this.pickupLat,
      required this.pickupLong,
      required this.destinationLat,
      required this.destinationLong,
      required this.fee,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  ListPenumpang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    pickupLat = json['pickup_lat'];
    pickupLong = json['pickup_long'];
    destinationLat = json['destination_lat'];
    destinationLong = json['destination_long'];
    fee = json['fee'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['destination_lat'] = this.destinationLat;
    data['destination_long'] = this.destinationLong;
    data['fee'] = this.fee;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
