import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:world_clock/features/home/weather_model.dart';
import 'package:world_clock/global/services/weather_service.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  String _city = '';
  String get city => _city;
  void setcity(String value) {
    _city = value;
    notifyListeners();
  }

  String _country = '';
  String get country => _country;
  void setcountry(String value) {
    _country = value;
    notifyListeners();
  }

  String _timezone = '';
  String get timezone => _timezone;
  void settimezone(String value, String symbol) {
    _timezone = '$symbol $value | GMT';
    notifyListeners();
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
      setcity(first.locality! + ',');
      setcountry(first.country!);
      await fetchweather(first.locality!);
      //  await getCurrencyName('')
      //String zone = await FlutterTimezone.getLocalTimezone();
      DateTime zonedate = DateTime.now();
      String zone = zonedate.timeZoneOffset.inHours.toString();
      String sym = '';
      if (!zonedate.timeZoneOffset.inHours.isNegative) {
        sym = '+';
      } else
        sym = '-';
      settimezone(zone, sym);
      getcountrycurrency(first.country!);
      getCurrencyName('United States of America');
      //  getGMTOffset(_country);
    } catch (e) {
      print('Error: $e');
    }
  }

  final _weatherService =
      WeatherService(apiKey: '7c37242b792cfc5f40c9a1f390571025');
  Weather? _weather;
  Weather? get weather => _weather;
  String _iconUrl = '';
  String get iconUrl => _iconUrl;

  void seticonUrl(String value) {
    _iconUrl = value;
    notifyListeners();
  }

  void setweather(var value) {
    _weather = value;
    notifyListeners();
  }

  Future<void> fetchweather(String city) async {
    try {
      // await Future.delayed(Duration(seconds: 1));
      var weather = await _weatherService.getWeather(city);
      String iconCode = weather.icon.toString();
      seticonUrl('http://openweathermap.org/img/w/$iconCode.png');
      setweather(weather);
    } catch (e) {
      print('error occurred $e');
    }
  }

  String _currency = '';
  String get currency => _currency;
  void setcurrency(String value) {
    _currency = value;
  }

  String _base = '';
  String get base => _base;
  void setbase(String value) {
    _base = value;
    notifyListeners();
  }

  String _currentcode = '';
  String get currentcode => _currentcode;

  void setcurrentcode(String value) {
    _currentcode = value;
    print('this is current code $_currentcode');
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
        setcurrentcode(code);
      }
    }
  }

  Future<void> getCurrencyName(String countryName) async {
    // Future.delayed(Duration(seconds: 1));
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

        setcurrency(currencyCode);
        // Future.delayed(Duration(seconds: 2));
        fetchExchangeRate(code, 'dd352ae5c00442eeacfa2f041ba57b88');
      }
    } else {
      print('Currency not found');
    }
  }

  Future<String> fetchCurrencyName(String currencyCode) async {
    final response = await http
        .get(Uri.parse('https://open.er-api.com/v6/currencies/$currencyCode'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> currencyData = json.decode(response.body);
      return currencyData['name'];
    }
    return 'Currency name not available';
  }

  String exchangekey = 'dd352ae5c00442eeacfa2f041ba57b88';
  double _exchangeRate = 0;
  double get exchangeRate => _exchangeRate;
  void setexchangerate(double value) {
    _exchangeRate = value;
    notifyListeners();
  }

  Future<void> fetchExchangeRate(String basecode, String exchangekey) async {
    final String apiUrl =
        'https://open.er-api.com/v6/latest/$basecode?apikey=$exchangekey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Future.delayed(Duration(seconds: 1));
        String er = data['rates'][_currentcode].toString();
        setexchangerate(double.parse(er).roundToDouble());
        print(er);
      } else {
        print('My Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('This Error: $e');
    }
  }
}
