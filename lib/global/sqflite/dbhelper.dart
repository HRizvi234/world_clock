import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:world_clock/global/sqflite/city_db.dart';

class DataBaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullpath async {
    const name = 'city.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullpath;
    var database =
        openDatabase(path, version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version) async =>
      await cityDB().createTable(database);
}
