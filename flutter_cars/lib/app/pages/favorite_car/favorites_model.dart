
import 'package:flutter/material.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/data/services/favorite_car_service.dart';

class FavoritesModel extends ChangeNotifier {
  List<Car> _cars = [];

  Future<List<Car>> fetch() async {
    _cars = await FavoriteCarService.fetch();
    notifyListeners();
    return _cars;
  }

  List<Car> get cars => _cars;

}