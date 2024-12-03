import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageDriverInfoPage extends StatelessWidget {
  const ManageDriverInfoPage({super.key});

  // Add driver info to Firestore
  Future<void> addDriverInfo(String driverName, String contact) async {
    try {
      await FirebaseFirestore.instance.collection('driver_info').add({
        'driver_name': driverName,
        'contact': contact,
      });
      Get.snackbar('Success', 'Driver info added successfully!',
          backgroundColor: Colors.green.shade700, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add driver info',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    }
  }

  // Edit driver info in Firestore
  Future<void> editDriverInfo(String id, String driverName, String contact) async {
    try {
      await FirebaseFirestore.instance.collection('driver_info').doc(id).update({
        'driver_name': driverName,
        'contact': contact,
      });
      Get.snackbar('Success', 'Driver info updated successfully!',
          backgroundColor: Colors.blue.shade700, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update driver info',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    }
  }

  // Delete driver info from Firestore
  Future<void> deleteDriverInfo(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('driver_info')
          .doc(id)
          .delete();
      Get.snackbar('Success', 'Driver info deleted successfully!',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete driver info',
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverNameController = TextEditingController();
    final contactController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Driver Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Add Driver Info Button
            ElevatedButton(
              onPressed: () {
                // Show dialog to add driver info
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Add New Driver Info'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: driverNameController,
                          decoration: const InputDecoration(
                            labelText: 'Driver Name',
                          ),
                        ),
                        TextField(
                          controller: contactController,
                          decoration: const InputDecoration(
                            labelText: 'Contact Information',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (driverNameController.text.isNotEmpty &&
                              contactController.text.isNotEmpty) {
                            addDriverInfo(
                                driverNameController.text,
                                contactController.text);
                            Navigator.pop(context); // Close dialog
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill all fields',
                              backgroundColor: Colors.red.shade700,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: const Text('Add'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Cancel
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Add New Driver Info'),
            ),
            const SizedBox(height: 20),
            // Display List of Existing Driver Info from Firebase
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('driver_info')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }
                final driverInfoList = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: driverInfoList.length,
                  itemBuilder: (context, index) {
                    final driverInfo = driverInfoList[index];
                    return ListTile(
                      title: Text(driverInfo['driver_name']),
                      subtitle: Text(driverInfo['contact']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Button
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Show dialog to edit driver info
                              driverNameController.text = driverInfo['driver_name'];
                              contactController.text = driverInfo['contact'];

                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Edit Driver Info'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: driverNameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Driver Name',
                                        ),
                                      ),
                                      TextField(
                                        controller: contactController,
                                        decoration: const InputDecoration(
                                          labelText: 'Contact Information',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        if (driverNameController.text.isNotEmpty &&
                                            contactController.text.isNotEmpty) {
                                          editDriverInfo(
                                              driverInfo.id,
                                              driverNameController.text,
                                              contactController.text);
                                          Navigator.pop(context); // Close dialog
                                        } else {
                                          Get.snackbar(
                                            'Error',
                                            'Please fill all fields',
                                            backgroundColor: Colors.red.shade700,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      child: const Text('Update'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context), // Cancel
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Delete Button
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Delete driver info from Firestore
                              deleteDriverInfo(driverInfo.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
