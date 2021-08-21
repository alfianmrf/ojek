import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojek/model/model.dart';
import 'package:ojek/utils/globalURL.dart';

class DriverModel with ChangeNotifier {
  late List<ListPenumpang> listPenumpang = [];
  late ListPenumpang onTheWay;
  late InfoDashBoard dashboardInfo;

  late bool isLoading = true;
  late bool isOnTheWay = false;

  Future<MessageResult> getListOrderNow(String token) async {
    Dashboard(token);
    var message = MessageResult(
        status: 500, message: "Maaf, ada Kesalahan Server", driverUuid: []);
    var res = await http.get(Uri.parse(currentOrderURL), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    var decode = json.decode(res.body);
    if (res.statusCode == 201) {
      isOnTheWay = false;
      getListPenumpang(token);
      return message;
    } else if (res.statusCode == 200) {
      isOnTheWay = true;
      onTheWay = ListPenumpang.fromJson(decode);
      message = MessageResult(
          status: res.statusCode, message: "Ada Orderan", driverUuid: []);
      isLoading = false;
      notifyListeners();
      return message;
    }
    return message;
  }

  Future<MessageResult> getListPenumpang(String token) async {
    listPenumpang = [];
    var message = MessageResult(
        status: 500, message: "Maaf, ada Kesalahan Server", driverUuid: []);
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
      message = MessageResult(status: 200, message: "Berhasil", driverUuid: []);
      isLoading = false;
      notifyListeners();
      return message;
    }
    isLoading = false;
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
    print(res.body);
    print(orderId);
    if (res.statusCode == 200) {
      getListOrderNow(token);
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<void> cancelOrder(int orderId, String token) async {
    var param = <String, dynamic>{"order_id": orderId};

    var res = await http.post(Uri.parse(cancelOrderDriverURL),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: json.encode(param));
    print(json.decode(res.body));
    if (res.statusCode == 200) {
      // getListPenumpang(token);
      getListOrderNow(token);
      notifyListeners();
    }
  }

  Future<void> Dashboard(token) async {
    var res = await http.get(
      Uri.parse(dashboardURL),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    var decode = json.decode(res.body);
    if (res.statusCode == 200) {
      dashboardInfo = InfoDashBoard.fromJson(decode);
    }
    print(json.encode(dashboardInfo));
    notifyListeners();
  }
}

class ListPenumpang {
  late int id;
  late int customerId;
  late String costumerName;
  late String pickupLat;
  late String pickupLong;
  late String destinationLat;
  late String destinationLong;
  late int fee;
  late String uuid;
  late String destinationAddress;
  // late String status;
  late String createdAt;
  late String updatedAt;

  ListPenumpang(
      {required this.id,
      required this.customerId,
      required this.pickupLat,
      required this.pickupLong,
      required this.costumerName,
      required this.destinationAddress,
      required this.destinationLat,
      required this.destinationLong,
      required this.fee,
      required this.uuid,
      // required this.status,
      required this.createdAt,
      required this.updatedAt});

  ListPenumpang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    pickupLat = json['pickup_lat'];
    costumerName = json['customer_name'];
    pickupLong = json['pickup_long'];
    destinationLat = json['destination_lat'];
    destinationLong = json['destination_long'];
    destinationAddress = json['destination_address'];
    fee = json['fee'];
    uuid = json['customer_uuid'];
    // status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.costumerName;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['destination_lat'] = this.destinationLat;
    data['destination_long'] = this.destinationLong;
    data['fee'] = this.fee;
    data['destination_address'] = this.destinationAddress;
    data['customer_uuid'] = this.uuid;
    // data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class InfoDashBoard {
  int? pendapatanHariIni;
  int? pendapatanBulanIni;
  int? pelangganHariIni;

  InfoDashBoard(
      {this.pendapatanHariIni, this.pendapatanBulanIni, this.pelangganHariIni});

  InfoDashBoard.fromJson(Map<String, dynamic> json) {
    pendapatanHariIni = json['pendapatan_hari_ini'];
    pendapatanBulanIni = json['pendapatan_bulan_ini'];
    pelangganHariIni = json['pelanggan_hari_ini'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pendapatan_hari_ini'] = this.pendapatanHariIni;
    data['pendapatan_bulan_ini'] = this.pendapatanBulanIni;
    data['pelanggan_hari_ini'] = this.pelangganHariIni;
    return data;
  }
}
