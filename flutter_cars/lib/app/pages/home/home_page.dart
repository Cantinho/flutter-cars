import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/home/cars_listview.dart';
import 'package:flutter_cars/app/pages/home/drawer_list.dart';
import 'package:flutter_cars/data/services/car_api.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Carros'),
          bottom: TabBar(
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
          children: <Widget>[
            CarsListView(
              carType: CarType.classic,
            ),
            CarsListView(carType: CarType.sport),
            CarsListView(
              carType: CarType.lux,
            ),
          ],
        ),
        drawer: DrawerList(),
      ),
    );
  }
}
