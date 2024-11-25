import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String studentName = '';
  String studentId = '';
  String department = '';
  String batch = '';

  // Reference to Firestore Collection
  final CollectionReference students =
  FirebaseFirestore.instance.collection('students');

  Future<void> _saveToFirebase() async {
    try {
      // Save data to Firestore
      await students.add({
        'name': studentName,
        'id': studentId,
        'department': department,
        'batch': batch,
        'created_at': FieldValue.serverTimestamp(),
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student registered successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Student Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    studentName = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Student ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    studentId = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the department';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    department = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Batch'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the batch';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    batch = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveToFirebase();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
