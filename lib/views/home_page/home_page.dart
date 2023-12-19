import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // location that the user has selected
  List<LatLng> selectedLocations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap'),
      ),

      body: FlutterMap(
        options:  MapOptions(
          onLongPress: (position, latlng){
            selectedLocations.add(latlng);
            setState(() {});
          },
          initialCenter: LatLng(26.5, 88.0),
          initialZoom: 12.0,
          maxZoom: 20.0,

        ),
        children: [

          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),

          for(var selectedLocation in selectedLocations)
          MarkerLayer(
            markers: [
              Marker(
                point: selectedLocation,
                width: 80,
                height: 80,
                child: Icon(Icons.location_on_outlined, color: Colors.red),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
