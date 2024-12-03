import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mama_bus_koi/student/student_login.dart';
import 'package:mama_bus_koi/admin/admin_login.dart';
import 'package:mama_bus_koi/student/student_homepage.dart';
import 'package:mama_bus_koi/admin/admin_homepage.dart';
import 'firebase_options.dart'; // Firebase configuration file
import 'splash.dart'; // Import the splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mama Bus Koi?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Start from the SplashScreen
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()), // Splash screen
        GetPage(name: '/studentLogin', page: () => const StudentloginPage()), // Student login
        GetPage(name: '/adminLogin', page: () => const AdminLoginPage()), // Admin login
        GetPage(name: '/studentHome', page: () => const StudentHomePage()), // Student home page
        GetPage(name: '/adminHome', page: () => const AdminHomePage()), // Admin home page
      ],
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Mama Bus Koi')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to student login
                Get.to(() => const StudentloginPage());
              },
              child: const Text('Student Login'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to admin login
                Get.to(() => const AdminLoginPage());
              },
              child: const Text('Admin Login'),
            ),
          ],
        ),
      ),
    );
  }
}

