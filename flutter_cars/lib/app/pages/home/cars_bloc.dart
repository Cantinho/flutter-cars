

import 'dart:async';
import 'package:flutter_cars/data/services/car_api.dart';
import 'package:flutter_cars/data/services/models/Car.dart';

class CarsBloc {

  final _streamController = StreamController<List<Car>>();

  Stream<List<Car>> get stream => _streamController.stream;

  fetch(final CarType carType) async {
    try {
      final List<Car> cars = await CarApi.fetchCars(carType);
      _streamController.add(cars);
    } catch (error) {
      _streamController.addError(error);
    }
  }

  void dispose() {
    _streamController.close();
  }
}