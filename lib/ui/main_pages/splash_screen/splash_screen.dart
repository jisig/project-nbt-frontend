import 'package:flutter/material.dart';
import 'dart:async';

import 'package:project_nbt/ui/main_pages/authentication/registration/registration_page.dart';
import 'package:project_nbt/ui/main_pages/authentication/sign_in/sign_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050714), // Matches image background
      body: SizedBox.expand(
        child: Image.asset(
          'lib/assets/splash_screen/splash_screen_image.png',
          fit: BoxFit.cover, // Fills the entire screen
        ),
      ),
    );
  }
}
