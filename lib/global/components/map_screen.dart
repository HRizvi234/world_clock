import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class FlutterMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  // final List<Marker> marker;
  // Initialise randomly generated Markers
  //static final _random = Random(42);
  // static final _initialCenter = LatLng(10, 20);

  FlutterMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<FlutterMapPage> createState() => _FlutterMapPageState();
}

class _FlutterMapPageState extends State<FlutterMapPage> {
  late double lat, lng;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lat = widget.latitude;
    lng = widget.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      nonRotatedChildren: [
        Center(
            // padding: EdgeInsets.symmetric(vertical: 160, horizontal: 140),
            // top: 175,
            //left: 150,
            child: Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ))
      ],
      // Add FlutterMap
      options: MapOptions(
          center: LatLng(
            lat,
            lng,
          ),
          zoom: 13,
          enableScrollWheel: false),
      children: [
        TileLayer(
          //retinaMode: true,
          // Show a satellite map background
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        //    MarkerLayer(markers: Marker(point: LatLng(latitude, longitude), builder: builder)), // Show the Markers
      ],
    );
  }
}
