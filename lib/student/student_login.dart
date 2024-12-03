import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../student/student_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import '../admin/admin_login.dart';

class StudentloginPage extends StatefulWidget {
  const StudentloginPage({super.key});

  @override
  _StudentloginPageState createState() => _StudentloginPageState();
}

class _StudentloginPageState extends State<StudentloginPage> {
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

  // Updated signUp function using Firebase Authentication
  Future<String?> signUp(SignupData data) async {
    setState(() => isLoading = true);

    // Input validation for email and password
    if (data.name == null || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(data.name!)) {
      setState(() => isLoading = false);
      return 'Please enter a valid email address';
    }
    if (data.password == null || data.password!.length < 6) {
      setState(() => isLoading = false);
      return 'Password must be at least 6 characters long';
    }

    try {
      // Use FirebaseAuth to create a new user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );

      // Send verification email
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      // Hide loading indicator
      setState(() => isLoading = false);

      // Customized SnackBar with enhanced design
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Welcome ${data.name}, You have successfully registered! Please log in now.',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.indigo.shade700,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      );

      // Wait for the SnackBar to show, then navigate back to login page
      await Future.delayed(Duration(seconds: 3));

      // Redirect to the student login page
      Get.off(() => const StudentloginPage());

      return null;
    } catch (e) {
      setState(() => isLoading = false);
      return e.toString(); // Return the error message if something goes wrong
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
                Get.off(() => const StudentHomePage());  // Navigate to homepage if login is successful
              }
              return result;  // Return the error message if login failed
            },
            onSignup: (SignupData data) => signUp(data),
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

          // Positioned "Admin Login" button with GIF
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Navigate to Admin Login Page
                Get.to(() => AdminLoginPage());
              },
              label: Row(
                children: [
                  const Icon(
                    Icons.admin_panel_settings, // Admin icon
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Admin Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.deepOrangeAccent,
              splashColor: Colors.orangeAccent,
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
