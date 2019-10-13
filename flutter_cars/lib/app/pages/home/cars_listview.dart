import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cars/app/pages/car_details/car_details_page.dart';
import 'package:flutter_cars/app/utils/nav.dart';
import 'package:flutter_cars/data/services/car_api.dart';
import 'package:flutter_cars/data/services/models/Car.dart';

class CarsListView extends StatefulWidget {
  final CarType carType;

  const CarsListView({Key key, this.carType}) : super(key: key);

  @override
  _CarsListViewState createState() => _CarsListViewState();
}

class _CarsListViewState extends State<CarsListView>
    with AutomaticKeepAliveClientMixin<CarsListView> {

  final _streamController = StreamController<List<Car>>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final List<Car> cars = await CarApi.fetchCars(widget.carType);
    _streamController.sink.add(cars);
  }

  _body() {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Center(
            child: Text(
              "It was not available fetch cars",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
              ),
            ),
          );
        }

        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<Car> cars = snapshot.data;
        return _listView(cars);
      },
    );
  }

  Container _listView(List<Car> cars) {
    return Container(
      margin: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: cars != null ? cars.length : 0,
        itemBuilder: (context, index) {
          final Car car = cars[index];
          return Card(
            color: Colors.grey[100],
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: car.urlPhoto != null
                        ? Image.network(
                            car.urlPhoto,
                            width: 250,
                          )
                        : Image.network(
                            "https://cdn0.iconfinder.com/data/icons/shift-travel/32/Speed_Wheel-512.png",
                            width: 150,
                          ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    car.name ?? "Pistons",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    "description...",
                    style: TextStyle(fontSize: 14),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('DETAILS'),
                          onPressed: () => _onClickCarDetails(car),
                        ),
                        FlatButton(
                          child: const Text('SHARE'),
                          onPressed: () => _onClickCarShare(car),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _onClickCarDetails(final Car car) {
    push(context, CarDetailsPage(car));
  }

  _onClickCarShare(final Car car) {}
}
