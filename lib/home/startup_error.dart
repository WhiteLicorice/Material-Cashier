// Dart file for the main entry point of the Flutter application

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartupError extends StatelessWidget {
  final String message;

  const StartupError({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disabling debug banner
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreen,
        useMaterial3: true, // Using Material 3 design
      ),
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green, // Setting app bar background color
            title: const Text(
              'Error',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
