// Dart file for the main entry point of the Flutter application

// Importing necessary packages and files
import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart'; // Importing Flutter's material library for UI components
import 'package:responsive_framework/responsive_framework.dart'; // Importing a package for making the app responsive
import 'package:provider/provider.dart'; // Importing flutter's provider package

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Screens
import 'home/my_home_page.dart';
import 'home/splash_screen.dart';
import 'home/startup_error.dart';

// Providers
import 'supplies/supply_provider.dart';

// Main function to run the application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Display the splash screen while initializing
  runApp(const SplashScreen());

  //sleep(Durations.extralong4);

  // Load secrets and connect to Supabase
  bool initializationSuccess = await _initializeApp();

  if (initializationSuccess) {
    // Run application after async loading
    runApp(
      ChangeNotifierProvider(
        create: (context) => SupplyProvider(), // Provide the SupplyProvider
        child: const MyApp(), //  Run application
      ),
    );
  }
}

// Place all async loading steps here
Future<bool> _initializeApp() async {
  try {
    // Load secrets
    await dotenv.load();

    // Connect to Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_PROJECT']!,
      anonKey: dotenv.env['SUPABASE_API_KEY']!,
    );

    final deviceName = await getDeviceName();

    // Log connection in supabase instance
    final response = await Supabase.instance.client.from('ping').insert({
      'device': deviceName,
    });

    if (response != null) {
      throw Exception('Database connection error.');
    }

    return true;
  } on SocketException catch (e) {
    // Catching network-related exceptions
    runApp(StartupError(message: 'Network error: $e'));
    return false;
  } catch (e) {
    // Catching other exceptions
    runApp(StartupError(message: 'Failed to initialize the app: $e'));
    return false;
  }
}

Future<String> getDeviceName() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  String deviceName;
  if (Platform.isAndroid) {
    var build = await deviceInfoPlugin.androidInfo;
    deviceName = build.model;
  } else if (Platform.isIOS) {
    var data = await deviceInfoPlugin.iosInfo;
    deviceName = data.name;
  } else {
    deviceName = 'unknown';
  }
  return deviceName;
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disabling debug banner
      title: 'Material Cashier', // Setting the title of the application
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreen,
        useMaterial3: true, // Using Material 3 design
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(
              start: 0,
              end: 450,
              name: MOBILE), // Responsive breakpoints for mobile
          const Breakpoint(
              start: 451,
              end: 800,
              name: TABLET), // Responsive breakpoints for tablet
          const Breakpoint(
              start: 801,
              end: 1920,
              name: DESKTOP), // Responsive breakpoints for desktop
          const Breakpoint(
              start: 1921,
              end: double.infinity,
              name: '4K'), // Responsive breakpoints for 4K screens
        ],
      ),
      home: const MyHomePage(
          title:
              'Material Cashier'), // Setting the home page of the application
    );
  }
}
