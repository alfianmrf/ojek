import 'package:flutter/material.dart';
import 'package:ojek/model/model.dart';
import 'package:ojek/screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = new MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppModel()),
      ChangeNotifierProvider(create: (context) => Register())
    ],
    child: Phoenix(
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
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
