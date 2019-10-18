import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/favorite_car/favorite_cars_bloc.dart';
import 'package:flutter_cars/app/pages/favorite_car/favorites_model.dart';
import 'package:flutter_cars/app/pages/splash/splash_page.dart';
import 'package:provider/provider.dart';

import 'app/utils/event_bus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final Map<int, Color> swatch =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EventBus>(
          builder: (context) => EventBus(),
          dispose: (context, bus) => bus.dispose(),
        ),
        ChangeNotifierProvider<FavoritesModel>(
          builder: (context) => FavoritesModel()
        )
      ],
      child: MaterialApp(
        // hide debug banner
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF880E4F, swatch),
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Inconsolata',
        ),
        home: SplashPage(),
      ),
    );
  }
}
