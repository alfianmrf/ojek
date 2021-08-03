part of 'model.dart';

class AppModel with ChangeNotifier {
  LoginAuth? auth;
  late bool logedIn = false;

  // AppModel() {
  //   getAuth();
  // }

  Future<LoginResult> setAuth(param) async {
    LoginResult _result = LoginResult(
        status: 500, message: "Terjadi kesaahan pada server", role: "");

    final res = await http.post(
      Uri.parse(loginURL),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(param),
    );
    final LocalStorage storage = LocalStorage("ojek");
    var decode = json.decode(res.body);
    if (res.statusCode == 200) {
      auth = LoginAuth.fromLocalJson(decode);
      logedIn = true;
      LoginResult _result = LoginResult(
        status: res.statusCode,
        message: "Berhasil",
        role: decode["user"]["role"],
      );
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem("auth", decode);
        notifyListeners();
        return _result;
      }
      return _result;
    }
    notifyListeners();
    return _result;
  }

  Future<void> getAuth() async {
    final LocalStorage storage = LocalStorage("ojek");
    try {
      final ready = await storage.ready;
      print(ready);
      if (ready) {
        final json = storage.getItem("auth");
        print(json);
        if (json != null) {
          auth = LoginAuth.fromLocalJson(json);
          logedIn = true;
          notifyListeners();
        }
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> logout() async {
    final LocalStorage storage = LocalStorage("ojek");
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.deleteItem("auth");
        auth = null;
        logedIn = false;
        notifyListeners();
      }
    } catch (err) {
      print(err);
    }
  }
}

class LoginAuth {
  String accessToken;
  String tokenType;
  int expiresAt;
  String name;
  String email;
  String role;
  String phone;
  int id;

  LoginAuth(this.accessToken, this.tokenType, this.expiresAt, this.name,
      this.email, this.id, this.role, this.phone);

  factory LoginAuth.fromLocalJson(Map<String, dynamic> json) {
    return LoginAuth(
      json["access_token"],
      json["token_type"],
      json["expires_in"],
      json["user"]["name"],
      json["user"]["email"],
      json["user"]["id"],
      json["user"]["role"],
      json["user"]["phone"],
    );
  }
}

class LoginResult {
  int status;
  String message;
  String role;
  LoginResult(
      {required this.status, required this.message, required this.role});
}
