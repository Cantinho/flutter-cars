import 'package:flutter/cupertino.dart';
import 'package:flutter_cars/app/utils/sql/database_helper.dart';
import 'package:flutter_cars/data/repositories/car.dart';
import 'package:flutter_cars/app/utils/sql/entity.dart';
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

  Future<List<T>> query(final String sql, [List<dynamic> arguments]) async {
    final databaseClient = await database;
    final list =  await databaseClient.rawQuery(sql, arguments);
    return list.map<T>((map) => fromMap(map)).toList();
  }

  Future<List<T>> findAll() {
    return query("select * from $tableName");
  }

  Future<T> findById(final int id) async {
    final List<T> list = await query("select * from $tableName where id=?", [id]);
    return list.length > 0 ? list.first : null;
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