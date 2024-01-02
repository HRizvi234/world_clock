import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:world_clock/global/sqflite/city_db.dart';
import 'package:world_clock/global/sqflite/data_model.dart';
import 'package:http/http.dart' as http;
import 'package:worldtime/worldtime.dart';

class ClocksProvider extends ChangeNotifier {
  String _weathericon = '';
  String get weathericon => _weathericon;
  set weathericon(String value) {
    _weathericon = value;
    notifyListeners();
  }

  double _latitude = 0;
  double get latitude => _latitude;
  void setlatitude(double value) {
    _latitude = value;
    notifyListeners();
  }

  double _longitude = 0;
  double get longitude => _longitude;
  void setlongitude(double value) {
    _longitude = value;
    notifyListeners();
  }

  String _minmax = '';
  String get minmax => _minmax;
  set minmax(String value) {
    _minmax = value;
    notifyListeners();
  }

  String _weatherdescription = '';
  String get weatherdescription => _weatherdescription;
  set weatherdescription(String value) {
    _weatherdescription = value;
    notifyListeners();
  }

  String _weathertemp = '';
  String get weathertemp => _weatherdescription;
  set weathertemp(String value) {
    _weathertemp = value;
    notifyListeners();
  }

  WeatherFactory wf = WeatherFactory('7c37242b792cfc5f40c9a1f390571025');

  Future<void> getdailyweather(String city) async {
    Weather w = await wf.currentWeatherByCityName(city);

    weatherdescription = w.weatherMain.toString();
    weathericon = w.weatherIcon.toString();
    weathertemp = w.temperature!.celsius!.round().toString() + ' °C ';
    minmax = w.tempMax!.celsius!.round().toString() +
        ' °C ' +
        ' / ' +
        w.tempMin!.celsius!.round().toString() +
        ' °C ';
  }

  List<Weather> _forecast = [];
  List<Weather> dailyforecast = [];
  List<Weather> weathercast = [];
  List<Weather> get forecast => _forecast;

  void setforecast(List<Weather> value) {
    _forecast = value;
    notifyListeners();
  }

  Future<void> getweather(String city) async {
    // _forecast.clear();
    dailyforecast = await wf.fiveDayForecastByCityName(city);
    //  print('This is forecast hour' + dailyforecast[0].date!.hour.toString());
    //setforecast(await wf.fiveDayForecastByCityName(city));
    forecast.clear();
    weathercast.clear();
    for (int i = 0; i < dailyforecast.length - 1; i++) {
      if (dailyforecast[i].date!.day != dailyforecast[i + 1].date!.day) {
        weathercast.add(dailyforecast[i]);
        print('success');
        //  print('This is after success hour' +
        //    weathercast[0].date!.hour.toString());
      }

      setforecast(weathercast);
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark first = placemarks.first;
      getcountrycurrency(first.country!);

      //  getGMTOffset(_country);
    } catch (e) {
      print('Error: $e');
    }
  }

  String _home = '';
  String get home => _home;
  void sethome(String value) {
    _home = value;
    print('this is current code $value');
    notifyListeners();
  }

  Future<void> getcountrycurrency(String name) async {
    String code = '';
    final response =
        await http.get(Uri.parse('https://restcountries.com/v2/name/$name'));
    if (response.statusCode == 200) {
      final List<dynamic> countries = json.decode(response.body);
      if (countries.isNotEmpty) {
        code =
            // countries[0]['currencies'][0]['symbol'].toString() +
            //     ' ' +
            countries[0]['currencies'][0]['code'].toString();
        sethome(code);
      }
    }
  }

  String exchangekey = 'dd352ae5c00442eeacfa2f041ba57b88';
  double _exchangeRate = 0;
  double get exchangeRate => _exchangeRate;
  void setexchangerate(double value) {
    _exchangeRate = value;
    print('This is exchange rate $_exchangeRate');
    //notifyListeners();
  }

  Future<void> fetchExchangeRate(String basecode) async {
    final String apiUrl =
        'https://open.er-api.com/v6/latest/$basecode?apikey=dd352ae5c00442eeacfa2f041ba57b88';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Future.delayed(Duration(seconds: 1));
        String er = data['rates'][_home].toString();
        setexchangerate(double.parse(er).roundToDouble());
        print('This is exchange rate $er');
      } else {
        print('My Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('This Error: $e');
    }
  }

  Future<void> getCurrencyName(String countryName) async {
    final response = await http
        .get(Uri.parse('https://restcountries.com/v2/name/$countryName'));
    if (response.statusCode == 200) {
      final List<dynamic> countries = json.decode(response.body);
      if (countries.isNotEmpty) {
        String currencyCode =
            // countries[0]['currencies'][0]['symbol'].toString() +
            //     ' ' +
            countries[0]['currencies'][0]['code'].toString();
        var code = countries[0]['currencies'][0]['code'].toString();
        //_base = currencyCode;
        //  setcurrency(currencyCode);
        fetchExchangeRate(code);
      }
    } else {
      print('Currency not found');
    }
  }

  DateTime _time = DateTime.now();
  DateTime get time => _time;

  void setTime(DateTime value) {
    _time = value;
    notifyListeners();
    print('this is current time $value');
  }

  String _currentTime = '';
  String get currentTime => _currentTime;

  void setcurrentTime(String value) {
    _currentTime = value;
    notifyListeners();
    print('this is current time $value');
  }

  Future<String> getCurrentTime(double latitude, double longitude) async {
    Worldtime worldTime = Worldtime();
    DateTime dt = await worldTime.timeByLocation(
        latitude: latitude, longitude: longitude);
    setTime(await worldTime.timeByLocation(
        latitude: latitude, longitude: longitude));
    _currentTime = '';
    setcurrentTime(DateFormat('h:mm a').format(dt));

    return DateFormat('h:mm a').format(dt);
  }

  String _currency = '';
  String get currency => _currency;
  set currency(String value) {
    _currency = value;
    notifyListeners();
  }
}
