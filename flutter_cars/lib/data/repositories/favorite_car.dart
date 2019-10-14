import 'package:flutter_cars/app/utils/sql/entity.dart';

import 'car.dart';

class FavoriteCar extends Entity {
  int id;

  FavoriteCar({this.id});

  FavoriteCar.fromCar(final Car car) {
    this.id = car.id;
  }

  FavoriteCar.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
