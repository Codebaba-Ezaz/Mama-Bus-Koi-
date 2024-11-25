import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageBusInfoPage extends StatefulWidget {
  const ManageBusInfoPage({super.key});

  @override
  _ManageBusInfoPageState createState() => _ManageBusInfoPageState();
}

class _ManageBusInfoPageState extends State<ManageBusInfoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Adding new bus info to Firestore
  void _addBus(BuildContext context) {
    final TextEditingController busNumberController = TextEditingController();
    final TextEditingController routeController = TextEditingController();
    final TextEditingController driverController = TextEditingController();
    final TextEditingController scheduleController = TextEditingController();  // Schedule field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Bus Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: busNumberController,
                decoration: const InputDecoration(labelText: 'Bus Number'),
              ),
              TextField(
                controller: routeController,
                decoration: const InputDecoration(labelText: 'Route'),
              ),
              TextField(
                controller: driverController,
                decoration: const InputDecoration(labelText: 'Driver'),
              ),
              TextField(
                controller: scheduleController,  // Schedule input
                decoration: const InputDecoration(labelText: 'Schedule (e.g., 9:00 AM - 5:00 PM)'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestore.collection('buses').add({
                  'busNumber': busNumberController.text,
                  'route': routeController.text,
                  'driver': driverController.text,
                  'schedule': scheduleController.text,  // Add schedule to Firestore
                }).then((value) {
                  Get.snackbar('Success', 'Bus added successfully', snackPosition: SnackPosition.BOTTOM);
                  Navigator.pop(context);
                }).catchError((error) {
                  Get.snackbar('Error', 'Failed to add bus: $error', snackPosition: SnackPosition.BOTTOM);
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Editing bus info
  void _editBus(BuildContext context, DocumentSnapshot bus) {
    final TextEditingController busNumberController = TextEditingController(text: bus['busNumber']);
    final TextEditingController routeController = TextEditingController(text: bus['route']);
    final TextEditingController driverController = TextEditingController(text: bus['driver']);
    final TextEditingController scheduleController = TextEditingController(text: bus['schedule']);  // Schedule field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Bus Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: busNumberController,
                decoration: const InputDecoration(labelText: 'Bus Number'),
              ),
              TextField(
                controller: routeController,
                decoration: const InputDecoration(labelText: 'Route'),
              ),
              TextField(
                controller: driverController,
                decoration: const InputDecoration(labelText: 'Driver'),
              ),
              TextField(
                controller: scheduleController,  // Schedule input
                decoration: const InputDecoration(labelText: 'Schedule'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bus.reference.update({
                  'busNumber': busNumberController.text,
                  'route': routeController.text,
                  'driver': driverController.text,
                  'schedule': scheduleController.text,  // Update schedule in Firestore
                }).then((value) {
                  Get.snackbar('Success', 'Bus updated successfully', snackPosition: SnackPosition.BOTTOM);
                  Navigator.pop(context);
                }).catchError((error) {
                  Get.snackbar('Error', 'Failed to update bus: $error', snackPosition: SnackPosition.BOTTOM);
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Deleting bus info
  void _deleteBus(DocumentSnapshot bus) {
    bus.reference.delete().then((value) {
      Get.snackbar('Success', 'Bus deleted successfully', snackPosition: SnackPosition.BOTTOM);
    }).catchError((error) {
      Get.snackbar('Error', 'Failed to delete bus: $error', snackPosition: SnackPosition.BOTTOM);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bus Info'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('buses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No buses available.'));
          }

          final buses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Text('Bus Number: ${bus['busNumber']}'),
                  leading: const Icon(Icons.directions_bus),
                  children: <Widget>[
                    ListTile(
                      title: Text('Route: ${bus['route']}'),
                    ),
                    ListTile(
                      title: Text('Driver: ${bus['driver']}'),
                    ),
                    ListTile(
                      title: Text('Schedule: ${bus['schedule']}'),  // Display schedule
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () => _editBus(context, bus),
                          child: const Text('Edit', style: TextStyle(color: Colors.blue)),
                        ),
                        TextButton(
                          onPressed: () => _deleteBus(bus),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addBus(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Bus Info',
      ),
    );
  }
}
