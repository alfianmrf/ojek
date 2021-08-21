import 'package:flutter/material.dart';
import 'package:ojek/model/driver_map_model.dart';
import 'package:ojek/model/map_model.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/model/notification.dart';
import 'package:ojek/model/searc_map.dart';
import 'package:ojek/model/user_model.dart';
import 'package:ojek/screen/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared.setAppId("302fc91f-1847-4650-9a8d-40d872fee45d");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  // HttpOverrides.global = new MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppModel()),
      ChangeNotifierProvider(create: (context) => Register()),
      ChangeNotifierProvider(create: (context) => MapSearch()),
      ChangeNotifierProvider(create: (context) => MapModel()),
      ChangeNotifierProvider(create: (context) => DriverModel()),
      ChangeNotifierProvider(create: (context) => NotificationDriver()),
      ChangeNotifierProvider(create: (context) => UserModel()),
    ],
    child: Phoenix(
      child: MyApp(),
    ),
  ));
}

String uuid = "";

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _getAppId() async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    print(osUserID);
    print(uuid);
  }

  void initState() {
    super.initState();
    _getAppId();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Ojek',
      home: SplashScreen(),
    );
  }
}
