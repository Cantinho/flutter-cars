import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/login/login_page.dart';
import 'package:flutter_cars/app/pages/splash/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // hide debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inconsolata',
      ),
      home: SplashPage(),
    );
  }
}
