import 'package:flutter_cars/app/utils/sql/base_dao.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/data/repositories/favorite_car.dart';

class FavoriteCarDAO extends BaseDAO<FavoriteCar> {

  static const String TABLE_NAME = "favorite_car";

  @override
  String get tableName => TABLE_NAME;

  @override
  FavoriteCar fromMap(Map<String, dynamic> map) {
    return FavoriteCar.fromJson(map);
  }

  Future<List<FavoriteCar>> findAllByCarId(final String type) async {
    final databaseClient = await database;
    final list = await databaseClient
        .rawQuery("select * from $tableName where id=?", [type]);
    return list.map((json) => fromMap(json)).toList();
  }
}
