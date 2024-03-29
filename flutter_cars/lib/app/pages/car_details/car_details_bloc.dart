import 'dart:async';

import 'package:flutter_cars/app/pages/car_details/page_state.dart';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/data/services/LoripsumApi.dart';
import 'package:flutter_cars/data/services/favorite_car_service.dart';

class CarDetailsBloc {

  final _streamController = StreamController<String>();
  final _streamFavoriteController = StreamController<bool>.broadcast();
  final _streamPageStateController = StreamController<PageState>();
  final _streamUserController = StreamController<User>();

  Stream<String> get stream => _streamController.stream;
  Stream<bool> get favoriteStream => _streamFavoriteController.stream;
  Stream<PageState> get pageStateStream => _streamPageStateController.stream;
  Stream<User> get userStream => _streamUserController.stream;

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

  void fetchFavorite(final Car car) async {
    final bool isFavorite = await FavoriteCarService.fetchFavorite(car);
    _streamFavoriteController.add(isFavorite);
  }

  void delete(final Car car) async {
    _streamPageStateController.add(Loading(title: "Details", message: "We're deleting the car..."));
    final bool wasDeleted = await FavoriteCarService.delete(car);
    if(wasDeleted) {
      _streamPageStateController.add(Success(title: "Details", message: "Success on delete car."));
      return;
    }
    _streamPageStateController.add(Error(title: "Details", message: "Unable to delete car from server."));
  }

  void fetchUser() async {
    final User user = await User.get();
    _streamUserController.add(user);
  }

  void dispose() {
    _streamController.close();
    _streamFavoriteController.close();
    _streamPageStateController.close();
    _streamUserController.close();
  }
}