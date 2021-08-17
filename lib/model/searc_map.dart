import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MapSearch with ChangeNotifier {
  Future<void> searchMap() async {
    var res = await http.post(
        Uri.parse(
            "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=amoeba&types=geocode&components=country:id&key=AIzaSyAvEY0wfdWGDfxEfXHjC8O0EyWVSzTqd9w"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        });
    print(json.decode(res.body));
  }
}
