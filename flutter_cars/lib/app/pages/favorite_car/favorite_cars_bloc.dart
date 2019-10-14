import 'dart:async';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/data/services/favorite_car_service.dart';

class FavoriteCarsBloc {

  final _streamController = StreamController<List<Car>>();

  Stream<List<Car>> get stream => _streamController.stream;

  fetch() async {
    try {
      final List<Car> cars = await FavoriteCarService.fetch();
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