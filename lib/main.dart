import 'package:flutter/material.dart';
import 'package:ojek/model/driver_map_model.dart';
import 'package:ojek/model/map_model.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/model/searc_map.dart';
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
    ],
    child: Phoenix(
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  void initState() {
    super.initState();
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
    });
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
