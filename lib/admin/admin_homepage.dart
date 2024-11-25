import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'manage_bus_info.dart';
import 'manage_driver_info.dart';
import '../admin/admin_login.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool _isLoggingOut = false; // Track logout state
  bool _isLoadingUsers = false; // Track loading state for users
  List<String> userEmails = []; // List to store user emails

  // Snackbar for success
  void showSuccessSnackbar(BuildContext context, String message) {
    Get.snackbar(
      'Success', // Title
      message, // Message
      icon: const Icon(Icons.check_circle, color: Colors.white),
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Snackbar for error
  void showErrorSnackbar(BuildContext context, String message) {
    Get.snackbar(
      'Error', // Title
      message, // Message
      icon: const Icon(Icons.error, color: Colors.white),
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Handle logout process
  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    // Simulate a delay for the logout process (e.g., Firebase sign out)
    await Future.delayed(const Duration(seconds: 2));

    // Show success snackbar
    showSuccessSnackbar(context, 'Logged out successfully');

    // Navigate to Admin Login Page
    Get.offAll(() => const AdminLoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Trigger logout process
              _logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Welcome text with big heading and some spacing
            const Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Manage Bus Info
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.orange.shade50,
              child: ListTile(
                leading: const Icon(Icons.directions_bus, color: Colors.orange),
                title: const Text('Manage Bus Info'),
                subtitle: const Text('Add, edit, or delete bus details'),
                onTap: () {
                  // Navigate to bus info management page
                  Get.to(() => const ManageBusInfoPage());
                },
              ),
            ),
            const SizedBox(height: 20),

            // Manage Driver Info
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.green),
                title: const Text('Manage Driver Info'),
                subtitle: const Text('View and manage all drivers'),
                onTap: () {
                  // Navigate to driver info management page
                  Get.to(() => const ManageDriverInfoPage());
                },
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.red.shade50,
              child: ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Logout'),
                subtitle: const Text('Log out from the admin panel'),
                onTap: () {
                  // Trigger logout process
                  _logout();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
