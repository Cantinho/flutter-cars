import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/car_form/car_form_page.dart';
import 'package:flutter_cars/app/pages/favorite_car/favorite_cars_page.dart';
import 'package:flutter_cars/app/pages/home/cars_page.dart';
import 'package:flutter_cars/app/pages/home/drawer_list.dart';
import 'package:flutter_cars/app/pages/home/home_page_bloc.dart';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/app/utils/app_colors.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/app/utils/prefs.dart';
import 'package:flutter_cars/data/services/car_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController _tabController;
  HomePageBloc _homePageBloc = HomePageBloc();

  @override
  void initState() {
    super.initState();
    _initTabs();
    _initUser();
  }

  _initTabs() async {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = await Prefs.getInt(("tabIdx"));
    _tabController.addListener(() {
      Prefs.setInt("tabIdx", _tabController.index);
    });
  }
  //[ROLE_ADMIN]
  _initUser() async {
    _homePageBloc.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carros'),
        backgroundColor: blendedRed(),
        bottom: TabBar(
          indicatorColor: white(),
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
      floatingActionButton: StreamBuilder<User>(
        stream: _homePageBloc.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null && snapshot.data.roles.contains("ROLE_ADMIN")) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: blendedRed(),
              onPressed: _onClickAddCar,
            );  
          } else {
            return Container();
          }
          
        }
      ),
    );
  }

  void _onClickAddCar() {
    push(context, CarFormPage());
  }

  @override
  void dispose() {
    _homePageBloc.dispose();
    super.dispose();
  }
}
