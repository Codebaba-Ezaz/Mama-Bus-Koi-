import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mama_bus_koi/student/student_login.dart'; // For navigation

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Delay the navigation to the next screen by 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      // Navigate to your next screen (e.g., AdminLoginPage or HomePage)
      // Adjust the navigation as per your app structure
      Get.offAll(() => const StudentloginPage());  // Example navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display your PNG image
            Image.asset(
              'assets/images/mamabuskoi.png', // Path to your PNG image
              width: 150, // Adjust the width as necessary
              height: 150, // Adjust the height as necessary
            ),
            const SizedBox(height: 20), // Space between image and text
            // Copyright Text with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.copyright, size: 16), // Copyright icon
                const SizedBox(width: 5),
                const Text(
                  'Ezaz Ahmed Sayem', // Your name under the copyright icon
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
