part of 'model.dart';

class Register with ChangeNotifier {
  Future<LoginResult> registerFunc(param) async {
    var result = LoginResult(
        status: 500, message: "Maaf terjadi kesalahan server.", role: "");
    var res = await http.post(
      Uri.parse(registerURL),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(param),
    );

    print(res.body);
    var decode = json.decode(res.body);

    if (res.statusCode == 201) {
      result = LoginResult(
          status: res.statusCode,
          message: decode["message"],
          role: decode["user"]["role"]);
      notifyListeners();
      return result;
    }
    notifyListeners();
    return result;
  }
}
