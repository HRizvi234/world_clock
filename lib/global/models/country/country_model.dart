class CountryModel {
  final String name;
  final double timezoneOffset;
  final String latlong;

  CountryModel({
    required this.name,
    required this.timezoneOffset,
    required this.latlong,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'],
      timezoneOffset: double.parse(json['timezone_offset'].toString()),
      latlong: json['latlong'],
    );
  }
}
