import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import 'MainWrapper.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final authStream = FirebaseAuth.instance.authStateChanges();
    final firstAuthState = await authStream.first;
    
    if (!mounted) return;
    
    if (firstAuthState != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0a032c),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo-removebg-preview.png',
              width: 150.w,
              height: 150.w,
            ),
            SizedBox(height: 20.h),
            Text(
              "Hami MiniMarket",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}