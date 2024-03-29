import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_cars/data/repositories/car_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  DatabaseHelper.getInstance();

  factory DatabaseHelper() => _instance;

  static Database _database;

  Future<Database> get database async {
    if(_database != null) {
      return _database;
    }
    _database = await _initDatabase();

    return _database;
  }

  Future _initDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, "cars.db");
    print("databse $path");
    var database= await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  void _onCreate(final Database database, final int newVersion) async {
    
    final List<String> createSqlList = (await rootBundle.loadString("assets/sql/create.sql")).split(";");
    for(String create in createSqlList) {
      if(create.trim().isNotEmpty) {
        await database.execute(create);
      }
    }
  }

  Future<FutureOr<void>> _onUpgrade(final Database database, final int oldVersion,
      int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");
    if(oldVersion == 1 && newVersion == 2) {
      await database.execute("alter table ${CarDAO.TABLE_NAME} add column NOVA TEXT");
    }
  }

  Future close() async {
    var databaseClient = await database;
    return databaseClient.close();
  }

}