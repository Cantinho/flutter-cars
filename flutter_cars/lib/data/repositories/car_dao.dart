import 'package:flutter_cars/app/utils/sql/base_dao.dart';
import 'package:flutter_cars/data/repositories/car.dart';

class CarDAO extends BaseDAO<Car> {

  static const String TABLE_NAME = "car";

  @override
  String get tableName => TABLE_NAME;

  @override
  Car fromMap(Map<String, dynamic> map) {
    return Car.fromJson(map);
  }

  Future<List<Car>> findAllByType(final String type) async {
    return query("select * from $tableName where type=?", [type]);
  }
}
