class DataModel {
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final String currency;
  final double gmt;

  DataModel(
      {required this.city,
      required this.country,
      required this.latitude,
      required this.longitude,
      required this.currency,
      required this.gmt});

  factory DataModel.fromSqfliteDatabase(Map<String, dynamic> map) => DataModel(
      city: map['city']?.toString() ?? '',
      country: map['country']?.toString() ?? '',
      latitude: double.parse(map['latitude']?.toString() ?? '0'),
      longitude: double.parse(map['longitude']?.toString() ?? '0'),
      currency: map['currency']?.toString() ?? '',
      gmt: double.parse(map['gmt']?.toString() ?? '0'));
}
