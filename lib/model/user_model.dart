import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojek/utils/globalURL.dart';

class UserModel with ChangeNotifier {
  InfoDriverJemput? infoDriverUser;
  bool isLoading = true;
  bool isDriverFound = false;

  Future<void> infoDriver(String token) async {
    isDriverFound = false;
    var res = await http.get(Uri.parse(infoDriverURL), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    var decode = json.decode(res.body);

    print(decode);

    if (res.statusCode == 200) {
      isDriverFound = true;
      infoDriverUser = InfoDriverJemput.fromJson(decode);
    }
    isLoading = false;
    notifyListeners();
  }
}

class InfoDriverJemput {
  int? id;
  String? name;
  String? nomorKendaraan;
  int? fee;

  InfoDriverJemput({this.id, this.name, this.nomorKendaraan, this.fee});

  InfoDriverJemput.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nomorKendaraan = json['nomor_kendaraan'];
    fee = json['fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nomor_kendaraan'] = this.nomorKendaraan;
    data['fee'] = this.fee;
    return data;
  }
}
