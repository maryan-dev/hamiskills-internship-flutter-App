// lib/screens/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'MainWrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds:5),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0a032c),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use your logo from assets
            Image.asset('assets/logo-removebg-preview.png', width: 150),
            const SizedBox(height: 20),
            const Text(
              "Hami MiniMarket",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}