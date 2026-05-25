import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LatLng currentLocation = LatLng(16.7040, 74.2433);

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: currentLocation,
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: currentLocation,
                builder: (ctx) => Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
