import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/favorite_car/favorite_cars_page.dart';
import 'package:flutter_cars/app/pages/home/cars_page.dart';
import 'package:flutter_cars/app/pages/home/drawer_list.dart';
import 'package:flutter_cars/app/utils/prefs.dart';
import 'package:flutter_cars/data/services/car_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initTabs();
  }

  _initTabs() async {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = await Prefs.getInt(("tabIdx"));
    _tabController.addListener(() {
      Prefs.setInt("tabIdx", _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carros'),
        backgroundColor: Color.alphaBlend(Colors.black38, Colors.pink),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: "Classic",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Sportive",
              icon: Icon(Icons.stars),
            ),
            Tab(
              text: "Lux",
              icon: Icon(Icons.star),
            ),
            Tab(
              text: "Favorite",
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          CarsPage(
            carType: CarType.classic,
          ),
          CarsPage(
            carType: CarType.sport,
          ),
          CarsPage(
            carType: CarType.lux,
          ),
          FavoriteCarsPage(),
        ],
      ),
      drawer: DrawerList(),
    );
  }
}
