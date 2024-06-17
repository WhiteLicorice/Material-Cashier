import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Wrap with MaterialApp
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      ),
    );
  }
}
