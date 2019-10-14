

import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/data/repositories/car_dao.dart';
import 'package:flutter_cars/data/repositories/favorite_car.dart';
import 'package:flutter_cars/data/repositories/favorite_car_dao.dart';

class FavoriteCarService {

  static favoriteCar(final Car car) {
    final FavoriteCar favoriteCar = FavoriteCar.fromCar(car);
    final dao = FavoriteCarDAO();
    dao.save(favoriteCar);
  }

  static void unfavoriteCar(final Car car) async {
    final FavoriteCar favoriteCar = FavoriteCar.fromCar(car);
    final dao = FavoriteCarDAO();
    final exists = await dao.exists(favoriteCar.id);
    if(exists) {
      dao.delete(favoriteCar.id);
    }
  }

  static Future<bool> fetchFavorite(Car car) async {
    final FavoriteCar favoriteCar = FavoriteCar.fromCar(car);
    final dao = FavoriteCarDAO();
    final exists = await dao.exists(favoriteCar.id);
    return exists;
  }

  static Future<List<Car>> fetch() async {
    // select * from car c, favorite f where c.id = f.id
    final List<Car> cars = await CarDAO().query("select * from car c, favorite_car f where c.id = f.id");
    print("cars >> $cars");
    return cars;
  }
}