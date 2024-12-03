import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../student/bus_location.dart';

class BusTrackPage extends StatelessWidget {
  const BusTrackPage({super.key});

  // Fetch bus details from Firestore
  Future<List<Map<String, dynamic>>> _fetchBusDetails() async {
    final snapshot = await FirebaseFirestore.instance.collection('buses').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Function to open the Google Maps page with the bus's location
  void _showBusLocation(BuildContext context, double lat, double lng) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusLocationPage(lat: lat, lng: lng),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Tracking'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBusDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No buses available.'));
          }

          final buses = snapshot.data!;
          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              final busNumber = bus['busNumber'] ?? 'Unknown';
              final route = bus['route'] ?? 'Unknown Route';
              final time = bus['time'] ?? 'Unknown Time';
              final lat = bus['location']['lat']?.toDouble() ?? 0.0;
              final lng = bus['location']['lng']?.toDouble() ?? 0.0;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text('$busNumber - $route'),
                  subtitle: Text('Time: $time'),
                  trailing: const Icon(Icons.directions_bus),
                  onTap: () => _showBusLocation(context, lat, lng), // Show location on tap
                ),
              );
            },
          );
        },
      ),
    );
  }
}
