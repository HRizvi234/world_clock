import 'package:flutter/material.dart';

class MapProvider extends ChangeNotifier {
  double _latitude = 30.3753;
  double get latitude => _latitude;
  set latitude(double value) {
    _latitude = value;
    notifyListeners();
    print('this is map latitude $_latitude');
  }

  double _longitude = 69.3451;
  double get longitude => _longitude;
  set longitude(double value) {
    _longitude = value;
    notifyListeners();
    print('this is map longitude $_longitude');
  }
}
