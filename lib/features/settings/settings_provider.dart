import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _check = false;
  bool get check => _check;

  setcheck(bool value) {
    _check = value;
    notifyListeners();
  }

  bool _check2 = false;
  bool get check2 => _check2;

  setcheck2(bool value) {
    _check2 = value;
    notifyListeners();
  }
}
