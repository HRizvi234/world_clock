import 'package:flutter/foundation.dart';

class Weather {
  final String city;
  final double temperature;
  final String condition;
  final String icon;

  Weather(
      {required this.temperature,
      required this.condition,
      required this.city,
      required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        city: json['name'],
        temperature: json['main']['temp'].toDouble(),
        condition: json['weather'][0]['main'],
        icon: json['weather'][0]['icon']);
  }
}
