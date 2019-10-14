

import 'dart:async';

import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/data/services/LoripsumApi.dart';
import 'package:flutter_cars/data/services/favorite_car_service.dart';

class CarDetailsBloc {

  final _streamController = StreamController<String>();
  final _streamFavoriteController = StreamController<bool>();

  Stream<String> get stream => _streamController.stream;
  Stream<bool> get favoriteStream => _streamFavoriteController.stream;

  fetch() async {
    String content = await LoripsumApi.getLoripsum();
    _streamController.add(content);
  }

  favorite(final Car car) async {
    FavoriteCarService.favoriteCar(car);
    _streamFavoriteController.add(true);
  }

  unfavorite(final Car car) async {
    FavoriteCarService.unfavoriteCar(car);
    _streamFavoriteController.add(false);
  }

  void dispose() {
    _streamController.close();
    _streamFavoriteController.close();
  }

  void fetchFavorite(final Car car) async {
    final bool isFavorite = await FavoriteCarService.fetchFavorite(car);
    _streamFavoriteController.add(isFavorite);
  }
}