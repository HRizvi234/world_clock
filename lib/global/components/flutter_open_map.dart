import 'package:flutter/material.dart';
import 'package:flutter_open_street_map/flutter_open_street_map.dart';

class FlutterOpenMap extends StatefulWidget {
  final double latitude, longitude;
  const FlutterOpenMap(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<FlutterOpenMap> createState() => _FlutterOpenMapState();
}

class _FlutterOpenMapState extends State<FlutterOpenMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterOpenStreetMap(
        locationIcon: Icons.location_on,
        locationIconColor: Colors.red,
        center: LatLong(widget.latitude, widget.longitude),
        onPicked: ((pickedData) {}));
  }
}
