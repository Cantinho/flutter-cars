import 'package:flutter_cars/data/repositories/base_dao.dart';
import 'package:flutter_cars/data/services/models/car.dart';

class CarDAO extends BaseDAO<Car> {

  static const String TABLE_NAME = "car";

  @override
  String get tableName => TABLE_NAME;

  @override
  Car fromMap(Map<String, dynamic> map) {
    return Car.fromJson(map);
  }

  Future<List<Car>> findAllByType(final String type) async {
    final databaseClient = await database;
    final list = await databaseClient
        .rawQuery("select * from $tableName where type=?", [type]);
    return list.map((json) => fromMap(json)).toList();
  }
}
