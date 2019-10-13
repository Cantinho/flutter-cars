import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/home/cars_listview.dart';
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
    _tabController = TabController(length: 3, vsync: this);
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
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: "Classics",
            ),
            Tab(
              text: "Sportives",
            ),
            Tab(
              text: "Lux",
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
        ],
      ),
      drawer: DrawerList(),
    );
  }
}
