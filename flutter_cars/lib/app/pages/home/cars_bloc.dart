

import 'dart:async';
import 'package:flutter_cars/app/utils/network.dart' as networkUtils;
import 'package:flutter_cars/data/repositories/car_dao.dart';
import 'package:flutter_cars/data/services/car_api.dart';
import 'package:flutter_cars/data/repositories/car.dart';

class CarsBloc {

  final _streamController = StreamController<List<Car>>();

  Stream<List<Car>> get stream => _streamController.stream;

  fetch(final CarType carType) async {

    final bool hasNetwork = await networkUtils.hasNetwork();

    if(!hasNetwork) {
      List<Car> cars = await CarDAO().findAllByType(parseCarType(carType));
      _streamController.add(cars);
      return cars;
    }

    try {
      final List<Car> cars = await CarApi.fetchCars(carType);
      _streamController.add(cars);
    } catch (error) {
      if(!_streamController.isClosed) {
        _streamController.addError(error);
      }
    }
  }

  void dispose() {
    _streamController.close();
  }
}