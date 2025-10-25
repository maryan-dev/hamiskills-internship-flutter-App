import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0a032c),

      appBar: AppBar(
      backgroundColor: Color(0XFF0a032c),
        title: Center(
          child: const Text(
            'Hami MiniMarket',
            style: TextStyle(color: Colors.white,fontSize: 25),
          ),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Browse fresh fruits and vegetables in our community shop.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



