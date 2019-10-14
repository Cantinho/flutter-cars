

import 'package:flutter/cupertino.dart';
import 'package:flutter_cars/data/repositories/database_helper.dart';
import 'package:flutter_cars/data/services/models/car.dart';
import 'package:flutter_cars/data/services/models/entity.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class BaseDAO<T extends Entity> {

  String get tableName;

  Future<Database> get database => DatabaseHelper.getInstance().database;

  T fromMap(Map<String, dynamic> map);

  Future<int> save(final T entity) async {
    final databaseClient = await database;
    final id = await databaseClient.insert(tableName, entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    print("id: $id");
    return id;
  }

  Future<List<T>> findAll() async {
    final databaseClient = await database;
    final list = await databaseClient.rawQuery("select * from $tableName");
    return list.map<T>((json) => fromMap(json)).toList();
  }

  Future<T> findById(final int id) async {
    final databaseClient = await database;
    final list = await databaseClient.rawQuery("select * from $tableName where id=?", [id]);
    if(list.length > 0) {
      return fromMap(list.first);
    }
    return null;
  }

  Future<bool> exists(final int id) async {
    final T retrievedModel = await findById(id);
    final exists = retrievedModel != null;
    return exists;
  }

  Future<int> delete(final int id) async {
    final databaseClient = await database;
    return await databaseClient.rawDelete("delete from $tableName where id=?", [id]);
  }

  Future<int> deleteAll() async {
    final databaseClient = await database;
    return await databaseClient.rawDelete("delete from $tableName");
  }

}