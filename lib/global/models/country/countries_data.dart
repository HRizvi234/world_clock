import 'dart:convert';

import 'package:country_state_city/models/country.dart';
import 'package:world_clock/global/models/country/country_model.dart';

class CountriesData {
  List<CountryModel> countries;

  CountriesData({
    required this.countries,
  });

  factory CountriesData.fromJson(String jsonData) {
    final parsed = json.decode(jsonData)["countries"] as List<dynamic>;
    List<CountryModel> countries =
        parsed.map((json) => CountryModel.fromJson(json)).toList();
    return CountriesData(countries: countries);
  }

  double getTimezoneOffsetByCountryName(String countryName) {
    CountryModel? country = countries.firstWhere(
        (element) => element.name.toLowerCase() == countryName.toLowerCase(),
        orElse: () => CountryModel(name: '', timezoneOffset: 0.0, latlong: ''));

    return country.timezoneOffset;
  }
}
