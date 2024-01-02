import 'package:sqflite/sqflite.dart';
import 'package:world_clock/global/sqflite/data_model.dart';
import 'package:world_clock/global/sqflite/dbhelper.dart';

class cityDB {
  final tablename = 'cities';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tablename
        (
          'city' TEXT NOT NULL, 
        'country' TEXT NOT NULL, 
        'latitude' DOUBLE NOT NULL,
         'longitude' DOUBLE NOT NULL,
          'currency' TEXT NOT NULL,
           'gmt' DOUBLE NOT NULL
           )""");
  }

  Future<int> create(
      {required String city,
      required String country,
      required String currency,
      required double latitude,
      required double longitude,
      required double gmt}) async {
    final database = await DataBaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename(city,country,currency,latitude,longitude,gmt) VALUES (?,?,?,?,?,?)''',
      [city, country, currency, latitude, longitude, gmt],
    );
  }

  Future<List<DataModel>> fetchall() async {
    final database = await DataBaseService().database;
    final cities = await database.rawQuery(''' SELECT * from $tablename ''');
    return cities.map((city) => DataModel.fromSqfliteDatabase(city)).toList();
  }

  Future<DataModel> fetchbyname(String city) async {
    final database = await DataBaseService().database;
    final datamodel = await database
        .rawQuery('''SELECT * from $tablename WHERE city=?''', [city]);
    return DataModel.fromSqfliteDatabase(datamodel.first);
  }

  Future<void> delete(String city) async {}
}
