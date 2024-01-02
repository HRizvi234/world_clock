import 'package:flutter/material.dart';
import 'package:world_clock/global/sqflite/city_db.dart';
import 'package:world_clock/global/sqflite/data_model.dart';

class ClockListProvider extends ChangeNotifier {
  List<DataModel> _datamodel = [];
  List<DataModel> get datamodel => _datamodel;
  set datamodel(List<DataModel> value) {
    _datamodel = value;
    notifyListeners();
  }

  final citydb = cityDB();
  Future<void> getlist() async {
    datamodel = await citydb.fetchall();
    print('this is city 1 ${datamodel[0].city}');
  }

  Future<bool> checklist() async {
    bool res = await datamodel.isNotEmpty;

    return res;
  }
}
