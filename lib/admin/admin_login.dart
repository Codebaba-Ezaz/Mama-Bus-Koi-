import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../admin/admin_homepage.dart';
import 'package:mama_bus_koi/student/student_login.dart'; // Ensure the student homepage is imported

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  bool isLoading = false; // To show loading indicator during auth process

  // Loading time
  Duration get loadingTime => const Duration(milliseconds: 2000);

  // Firebase authentication function
  Future<String?> authUser(LoginData data) async {
    setState(() => isLoading = true);  // Show loading indicator during auth

    try {
      // Authenticate with Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name!,
          password: data.password!
      );

      setState(() => isLoading = false);  // Hide loading indicator
      return null;  // null means successful login
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);  // Hide loading indicator
      return e.message;  // Return the Firebase error message
    }
  }

  // Recover password (optional)
  Future<String?> recoverPassword(String email) async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() => isLoading = false);
      return 'Password recovery email sent';
    } catch (e) {
      setState(() => isLoading = false);
      return e.toString();  // Return error message
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(20.0),
      top: Radius.circular(10.0),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          FlutterLogin(
            title: 'মামা বাস কই?',
            logo: const AssetImage('assets/images/mamabuskoi.png'),
            onLogin: (LoginData data) async {
              final result = await authUser(data);
              if (result == null) {
                Get.off(() => const AdminHomePage());  // Navigate to homepage if login is successful
              }
              return result;  // Return the error message if login failed
            },
            onRecoverPassword: (String email) => recoverPassword(email),
            theme: LoginTheme(
              primaryColor: Colors.indigo,
              accentColor: Colors.cyanAccent,
              errorColor: Colors.redAccent,
              titleStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 3),
                ],
              ),
              bodyStyle: const TextStyle(
                color: Colors.black87,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
              ),
              textFieldStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              buttonStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              cardTheme: CardTheme(
                color: Colors.indigo.shade50,
                elevation: 6,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              inputTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                  borderRadius: inputBorder,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo.shade600, width: 2),
                  borderRadius: inputBorder,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade600, width: 2),
                  borderRadius: inputBorder,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade900, width: 2),
                  borderRadius: inputBorder,
                ),
              ),
              buttonTheme: LoginButtonTheme(
                backgroundColor: Colors.indigo.shade700,
                splashColor: Colors.lightBlue,
                elevation: 5,
                highlightElevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Positioned "Student Login" button with icon
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Navigate to Student HomePage on click
                Get.to(() => const StudentloginPage());
              },
              label: Row(
                children: [
                  const Icon(
                    Icons.school, // Student icon
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Student Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.greenAccent,
              splashColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
            ),
          ),

          // Display a loading indicator when logging in
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
