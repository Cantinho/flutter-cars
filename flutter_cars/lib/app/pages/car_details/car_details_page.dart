import 'package:flutter/material.dart';
import 'package:flutter_cars/data/services/models/Car.dart';

class CarDetailsPage extends StatelessWidget {

  Car _car;

  CarDetailsPage(this._car);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_car.name ?? "Pistons"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: _car.urlPhoto != null
          ? Image.network(
        _car.urlPhoto,
      )
          : Image.network(
        "https://cdn0.iconfinder.com/data/icons/shift-travel/32/Speed_Wheel-512.png",
      ),
    );
  }

}
