import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<void> navigateBasedOnAuth(BuildContext context) async {
    // Check if a user is currently signed in using Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in, navigate to HomePage
      print("User found, navigating to HomePage...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // No user signed in, navigate to RegisterPage
      print("No user data, navigating to RegisterPage...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger navigation logic after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) => navigateBasedOnAuth(context));

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while waiting
      ),
    );
  }
}
