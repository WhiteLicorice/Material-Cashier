import 'dart:async';
import 'dart:io';
import 'package:brm_cashier/auth/sign_in_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

// Screens
import 'home/my_home_page.dart';
import 'home/startup_error.dart';

// Providers
import 'supplies/supply_provider.dart';

var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_PROJECT']!,
    anonKey: dotenv.env['SUPABASE_API_KEY']!,
  );
  runApp(const InitialApp());
}

class InitialApp extends StatelessWidget {
  const InitialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material Cashier',
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreen,
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while initializing
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          // Show an error message if initialization failed
          return const MaterialApp(
            home: StartupError(message: 'Failed to initialize the app'),
          );
        } else {
          // Initialization successful, fetch supplies and proceed to the main app
          final supplyProvider = SupplyProvider();
          supplyProvider.fetchSupplies(); // Fetch supplies here

          return ChangeNotifierProvider(
            create: (context) => supplyProvider,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Material Cashier',
              theme: ThemeData(
                colorSchemeSeed: Colors.lightGreen,
                useMaterial3: true,
              ),
              builder: (context, child) => ResponsiveBreakpoints.builder(
                child: child!,
                breakpoints: const [
                  Breakpoint(start: 0, end: 450, name: MOBILE),
                  Breakpoint(start: 451, end: 800, name: TABLET),
                  Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                ],
              ),
              home: const MyHomePage(title: 'Material Cashier'),
            ),
          );
        }
      },
    );
  }
}

Future<bool> _initializeApp() async {
  try {
    final deviceName = await getDeviceName();

    // Log connection in supabase instance
    final response = await Supabase.instance.client.from('ping').insert({
      'device': deviceName,
    });

    if (response != null) {
      throw Exception('Database connection error.');
    }

    //await Supabase.instance.client.auth.signInAnonymously();

    return true;
  } on SocketException catch (e) {
    // Catching network-related exceptions
    logger.d(e);
    runApp(const StartupError(message: 'Network error'));
    return false;
  } catch (e) {
    logger.d(e);
    // Catching other exceptions
    runApp(const StartupError(message: 'Failed to initialize the app'));
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
    var build = await deviceInfoPlugin.iosInfo;
    deviceName = build.model;
  } else {
    deviceName = 'unknown';
  }
  return deviceName;
}
