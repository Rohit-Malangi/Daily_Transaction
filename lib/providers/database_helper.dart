import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tableName = 'myTable';
  static final id = '_id';
  static final name = '_name';
  static final price = '_price';
  static final date = '_date';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  Future<Database> _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    var _db =
        await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tableName( $id INTEGER PRIMARY KEY AUTOINCREMENT, $name TEXT , $price REAL , $date TEXT NOT NULL)');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    var x = await db.insert(DatabaseHelper._tableName, row);
    return x;
  }

  Future<List<Map<String, dynamic>>> query() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db
        .query("$_tableName", columns: ['$id', '$name', '$price', '$date']);
    return result;
  }

  Future<int> delete(int i) async {
    Database db = await instance.database;
    return await db.delete('$_tableName', where: '$id=?', whereArgs: [i]);
  }
}
