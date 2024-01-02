import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:weather/weather.dart';
import 'package:world_clock/global/constants/citylist.dart';
import 'package:world_clock/global/models/country/countries_data.dart';
import 'package:world_clock/global/constants/country_list.dart';

import 'package:worldtime/worldtime.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class SearchProvider extends ChangeNotifier {
  String _home = '';
  String get home => _home;
  void sethome(String value) {
    _home = value;
    print('this is current code $value');
    notifyListeners();
  }

  Future<bool> checkcity() async {
    bool res = false;
    if (cityname.isNotEmpty) {
      res = true;
    }
    return res;
  }

  Future<bool> checklist() async {
    bool res = false;
    if (cities.isNotEmpty) {
      res = true;
    }
    return res;
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
      //  setlatitude(position.latitude);
      // setlongitude(position.longitude);

      //  getGMTOffset(_country);
    } catch (e) {
      print('Error: $e');
    }
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

  List<dynamic> cities = [];
  List<dynamic> filtercities = [];

  String _countryname = '';
  String get countryname => _countryname;
  void setcountryname(String value) {
    _countryname = value;
    notifyListeners();
  }

  String _cityname = '';
  String get cityname => _cityname;
  void setcityname(String value) {
    _cityname = value;

    findcountry(_cityname);
    Timer.periodic(Duration(minutes: 1), (timer) {
      getCurrentTime(_latitude, _longitude);
    });

    //Future.delayed(Duration(seconds: 1));
    //getContinentForCity(value);
    notifyListeners();
  }

  double _latitude = 0;
  double get latitude => _latitude;
  void setlatitude(double value) {
    _latitude = value;
    print('this is searced latitude $_latitude');
    notifyListeners();
  }

  double _longitude = 0;
  double get longitude => _longitude;
  void setlongitude(double value) {
    _longitude = value;
    print('this is searced longitude $_longitude');
    notifyListeners();
  }

  Future<void> getcitites() async {
    try {
      cities = await jsonDecode(jsonCity);
      //allcities = await getAllCities();
      filtercities = cities;
      print(cities[40]['name']);
      getCurrentLocation();
    } catch (e) {
      print('couldn' 't fetch citites $e');
    }
  }

  void filter(String text) {
    filtercities = cities
        .where(
            (city) => city['name'].toLowerCase().contains(text.toLowerCase()))
        .toList();
    notifyListeners();
  }

  double lat = 0;
  double lng = 0;
  Future<void> findcountry(String city) async {
    try {
      List<Location> location = await locationFromAddress(city);

      if (location.isNotEmpty) {
        // Get the country name from the first result
        List<Placemark> placemark = await placemarkFromCoordinates(
            double.parse(location[0].latitude.toString()),
            double.parse(location[0].longitude.toString()));

        getCurrentTime(location[0].latitude, location[0].longitude);

        //setcurrentTime(DateFormat.Hm().format(placemark[0].));

        if (placemark[0].country == 'United States') {
          String fullcountry = 'United States of America';
          setlatitude(location[0].latitude);
          setlongitude(location[0].longitude);
          setcountryname(fullcountry);
          getCurrencyName(fullcountry);
          setOffset(fullcountry);
          print(fullcountry);
        } else {
          setlatitude(location[0].latitude);
          setlongitude(location[0].longitude);
          setcountryname(placemark[0].country ?? 'Not found');

          getCurrencyName(placemark[0].country.toString());
          setOffset(placemark[0].country.toString() ?? '');

          print(_countryname);
        }
      }
    } catch (e) {
      print('Cannot fetch country $e');
    }
  }

  List<Map<String, dynamic>> weeklyWeather = [];
  final apiUrl = 'http://api.openweathermap.org/data/2.5/forecast';

  Future<void> getWeeklyWeather(String city) async {
    final apiUrl =
        'http://api.openweathermap.org/data/2.5/forecast?q=texas&appid=7c37242b792cfc5f40c9a1f390571025';
    final response = await http.get(Uri.parse('$apiUrl?q=$city&appid='));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['cod'] == '200') {
        // Extract the list of daily weather data from the API response
        weeklyWeather = List<Map<String, dynamic>>.from(data['list']);
      } else {
        // Handle error from the API
        print('Error: ${data['message']}');
      }
    } else {
      // Handle HTTP error
      print('HTTP error ${response.statusCode}');
    }
  }

  String exchangekey = 'dd352ae5c00442eeacfa2f041ba57b88';
  double _exchangeRate = 0;
  double get exchangeRate => _exchangeRate;
  void setexchangerate(double value) {
    _exchangeRate = value;
    print('This is exchange rate $_exchangeRate');
    notifyListeners();
  }

  String _currency = '';
  String get currency => _currency;
  void setcurrency(String value) {
    _currency = value;
    print('This is currency $value');
    notifyListeners();
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
        setcurrency(currencyCode);
        fetchExchangeRate(code, 'dd352ae5c00442eeacfa2f041ba57b88');
      }
    } else {
      print('Currency not found');
    }
  }

  Future<void> fetchExchangeRate(String basecode, String exchangekey) async {
    final String apiUrl =
        'https://open.er-api.com/v6/latest/$basecode?apikey=$exchangekey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Future.delayed(Duration(seconds: 1));
        String er = data['rates'][_home].toString();
        setexchangerate(double.parse(er).roundToDouble());
        print(er);
      } else {
        print('My Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('This Error: $e');
    }
  }

  String _currentTime = '';
  String get currentTime => _currentTime;

  void setcurrentTime(String value) {
    _currentTime = value;
    notifyListeners();
    print('this is current time $value');
  }

  DateTime _time = DateTime.now();
  DateTime get time => _time;

  void setTime(DateTime value) {
    _time = value;
    notifyListeners();
    print('this is current time $value');
  }

  double _offval = 0;
  double get offval => _offval;
  set offval(double value) {
    _offval = value;
    notifyListeners();
  }

  CountriesData cd = CountriesData.fromJson(jsonData);
  String _soffset = '';
  String get soffset => _soffset;
  void setOffset(String country) {
    double val = cd.getTimezoneOffsetByCountryName(country);
    _offval = val;
    print('This is country offset $val');
    String sym = '+';
    if (val.isNegative) {
      sym = '';
    }
    _soffset = sym + val.toString();
    gmt = val;
    notifyListeners();

    print('this is offset time by country name${_soffset}');
  }

  double _gmt = 0.0;
  double get gmt => _gmt;
  set gmt(double value) {
    _gmt = value;
    notifyListeners();
  }

  Future<void> getCurrentTime(double latitude, double longitude) async {
    Worldtime worldTime = Worldtime();

    setTime(await worldTime.timeByLocation(
        latitude: latitude, longitude: longitude));
    setcurrentTime(DateFormat('h:mm a').format(_time));

    //return worldTime.getTime();
  }

  String _continent = '';
  String get continent => _continent;
  void setcontnent(String value) {
    print('this is current continent $value');
    _continent = value;
    notifyListeners();
  }

  List<Weather> _forecast = [];
  List<Weather> dailyforecast = [];
  List<Weather> weathercast = [];
  List<Weather> get forecast => _forecast;

  void setforecast(List<Weather> value) {
    _forecast = value;
    notifyListeners();
  }

  WeatherFactory wf = WeatherFactory('7c37242b792cfc5f40c9a1f390571025');

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

  String _weathericon = '';
  String get weathericon => _weathericon;
  set weathericon(String value) {
    _weathericon = value;
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

  String _hr = '';
  String get hr => _hr;

  set hr(String value) {
    _hr = value;
    print('this is the weather timezone name $_hr');
    notifyListeners();
  }

  Future<void> getdailyweather(String city) async {
    Weather w = await wf.currentWeatherByCityName(city);
    hr = w.date!.timeZoneName.toString();
    weatherdescription = w.weatherMain.toString();
    weathericon = w.weatherIcon.toString();
    weathertemp = w.temperature!.celsius!.round().toString() + ' °C ';
    minmax = w.tempMax!.celsius!.round().toString() +
        ' °C ' +
        ' / ' +
        w.tempMin!.celsius!.round().toString() +
        ' °C ';
  }
}
