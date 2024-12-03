import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../student/bus_track.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;
  String? _studentId;  // To store the student's ID

  // Fetch the student's personal information from Firestore
  Future<void> _fetchStudentData() async {
    final studentDoc = await FirebaseFirestore.instance
        .collection('students')
        .doc(_studentId)
        .get();

    if (studentDoc.exists) {
      var studentData = studentDoc.data();
      if (studentData != null) {
        _fullNameController.text = studentData['fullName'] ?? '';
        _idController.text = studentData['studentID'] ?? '';
        _deptController.text = studentData['department'] ?? '';
        _locationController.text = studentData['location'] ?? '';
      }
    } else {
      Get.snackbar('Error', 'Student data not found',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Function to save personal information in Firestore
  Future<void> _savePersonalInfo() async {
    if (_fullNameController.text.isEmpty ||
        _idController.text.isEmpty ||
        _deptController.text.isEmpty ||
        _locationController.text.isEmpty) {
      Get.snackbar('Error', 'All fields must be filled',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // Save data to Firestore
      await FirebaseFirestore.instance
          .collection('students')
          .doc(_idController.text)
          .set({
        'fullName': _fullNameController.text,
        'studentID': _idController.text,
        'department': _deptController.text,
        'location': _locationController.text,
      });

      setState(() {
        _isEditing = false;
      });

      showSuccessSnackbar(context, 'Personal Information Updated!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update information',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Snackbar for success
  void showSuccessSnackbar(BuildContext context, String message) {
    Get.snackbar(
      'Success',
      message,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Logout functionality with loading indicator
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulating logout process

    setState(() {
      _isLoading = false;
    });

    Get.snackbar(
      'Success',
      'Successfully logged out',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate to login page
    Navigator.pushReplacementNamed(context, '/student-login'); // Update with actual login page route
  }

  @override
  void initState() {
    super.initState();

    // Assuming the student ID is available after login (for example, stored in SharedPreferences or passed as an argument)
    // Replace this with how you handle authentication or getting the student's ID.
    _studentId = 'exampleStudentID'; // For demonstration, replace with actual student ID

    _fetchStudentData();
  }

  Widget buildStudentDashboard() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Personal Information Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: _isEditing
                ? [
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Student ID'),
              ),
              TextField(
                controller: _deptController,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                    labelText: 'Location (Pickup point)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePersonalInfo,
                child: const Text('Save Information'),
              ),
            ]
                : [
              ListTile(
                title: Text(
                    'Full Name: ${_fullNameController.text.isEmpty ? "Not Set" : _fullNameController.text}'),
              ),
              ListTile(
                title: Text(
                    'Student ID: ${_idController.text.isEmpty ? "Not Set" : _idController.text}'),
              ),
              ListTile(
                title: Text(
                    'Department: ${_deptController.text.isEmpty ? "Not Set" : _deptController.text}'),
              ),
              ListTile(
                title: Text(
                    'Location: ${_locationController.text.isEmpty ? "Not Set" : _locationController.text}'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: const Text('Edit Info'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Bus Track Button
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to the BusTrackPage using Get.to()
            Get.to(() => BusTrackPage());
          },
          icon: const Icon(Icons.directions_bus),
          label: const Text('Bus Track'),
        ),
        // Logout Button
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.exit_to_app),
          label: const Text('Logout'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: buildStudentDashboard(),
    );
  }
}
