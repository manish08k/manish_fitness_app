import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FitnessMapPage extends StatefulWidget {
  const FitnessMapPage({super.key});

  @override
  State<FitnessMapPage> createState() => _FitnessMapPageState();
}

class _FitnessMapPageState extends State<FitnessMapPage> {

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId("gym1"),
      position: LatLng(17.385044, 78.486671), // Hyderabad example
      infoWindow: InfoWindow(
        title: "Power Gym",
        snippet: "Registered Fitness Center",
      ),
    ),
    const Marker(
      markerId: MarkerId("gym2"),
      position: LatLng(17.4000, 78.4800),
      infoWindow: InfoWindow(
        title: "FitZone Studio",
        snippet: "Yoga & Cardio Center",
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fitness Locations")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(17.385044, 78.486671),
          zoom: 13,
        ),
        markers: _markers,
        myLocationEnabled: true,
      ),
    );
  }
}
