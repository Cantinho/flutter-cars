

import 'package:flutter/cupertino.dart';
import 'package:flutter_cars/data/repositories/database_helper.dart';
import 'package:flutter_cars/data/services/models/car.dart';
import 'package:sqflite/sqlite_api.dart';

class CarDAO {

  static const String TABLE_CAR = "car";

  static String get carTableName => TABLE_CAR;

  Future<Database> get database => DatabaseHelper.getInstance().database;

  Future<int> save(final Car car) async {
    final databaseClient = await database;
    final id = await databaseClient.insert(TABLE_CAR, car.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    print("id: $id");
    return id;
  }

  Future<List<Car>> findAll() async {
    final databaseClient = await database;
    final list = await databaseClient.rawQuery("select * from $TABLE_CAR");
    final cars = list.map<Car>((json) => Car.fromJson(json)).toList();
    return cars;
  }

  Future<List<Car>> findAllByType(final String type) async {
    final databaseClient = await database;
    final list = await databaseClient.rawQuery("select * from $TABLE_CAR where type=?", [type]);
    final cars = list.map((json) => Car.fromJson(json)).toList();
    return cars;
  }

  Future<Car> findById(final int id) async {
    final databaseClient = await database;
    final list = await databaseClient.rawQuery("select * from $TABLE_CAR where id=?", [id]);
    if(list.length > 0) {
      return new Car.fromJson(list.first);
    }
    return null;
  }

  Future<bool> exists(final Car car) async {
    final Car retrievedCar = await findById(car.id);
    final exists = retrievedCar != null;
    return exists;
  }

  Future<int> delete(final int id) async {
    final databaseClient = await database;
    return await databaseClient.rawDelete("delete from $TABLE_CAR where id=?", [id]);
  }

  Future<int> deleteAll() async {
    final databaseClient = await database;
    return await databaseClient.rawDelete("delete from $TABLE_CAR");
  }

}