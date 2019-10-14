import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cars/app/pages/home/home_page.dart';
import 'package:flutter_cars/app/pages/login/login_page.dart';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/data/repositories/database_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final String assetName = "assets/pistons.svg";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
          color: Colors.black87,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "P I S T O N S",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  child: SvgPicture.asset(
                    assetName,
                    height: 150,
                    width: 150,
                    color: Color.alphaBlend(Colors.black38, Colors.pink),
                    semanticsLabel: 'A red up arrow',
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    final Future waitForAWhile = Future.delayed(Duration(seconds: 4));
    final Future accessDatabase = DatabaseHelper.getInstance().database;
    final Future<User> fetchUserFromSharedPreference = User.get();

    Future.wait([waitForAWhile, accessDatabase, fetchUserFromSharedPreference]).then((List values) {
      final User user = values[2];
;      if (user != null) {
        push(context, HomePage(), replace: true);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }
}
