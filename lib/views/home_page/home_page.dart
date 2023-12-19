import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_street_map/services/location_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // location that the user has selected
  List<LatLng> selectedLocations = [];

  // current user location
  LatLng? currentLocation;

  // controller for the map
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          LocationServices().determinePosition().then((value) {
            log("location $value");

            // moving the map to the user position
            _mapController.move(LatLng(value.latitude, value.longitude), 12);

            setState(() {
              currentLocation = LatLng(value.latitude, value.longitude);
            });
          }).onError((error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
              ),
            );
          });
        },
        child: const Icon(Icons.location_searching),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onLongPress: (position, latlng) {
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

          // user location
          if (currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: currentLocation!,
                  width: 80,
                  height: 80,
                  child: Icon(Icons.circle, color: Colors.blue),
                ),
              ],
            ),

          // user selected locations
          for (var selectedLocation in selectedLocations)
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
