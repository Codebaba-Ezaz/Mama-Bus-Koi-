import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusLocationPage extends StatefulWidget {
  final double lat;
  final double lng;

  const BusLocationPage({super.key, required this.lat, required this.lng});

  @override
  _BusLocationPageState createState() => _BusLocationPageState();
}

class _BusLocationPageState extends State<BusLocationPage> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Location'),
        backgroundColor: Colors.blueAccent,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId('busLocation'),
            position: LatLng(widget.lat, widget.lng),
            infoWindow: const InfoWindow(title: 'Bus Location'),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
