// Dart file for the main entry point of the Flutter application

// Importing necessary packages and files
import 'package:brm_cashier/transaction/transact_screen.dart'; // Importing a screen for transaction functionality
import 'package:flutter/material.dart'; // Importing Flutter's material library for UI components
import 'package:flutter/services.dart'; // Importing Flutter's services library for controlling system-level events
import 'package:responsive_framework/responsive_framework.dart'; // Importing a package for making the app responsive
import 'package:provider/provider.dart'; //  Importing flutter's provider package

// Internal imports
import 'utils/_responsive_values.dart'; // Importing utility functions related to responsiveness

// Provider imports
import 'supplies/supply_provider.dart';

// Main function to run the application
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SupplyProvider(), // Provide the SupplyProvider
      child: const MyApp(),
    ),
  );
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
              'Material Cashier '), // Setting the home page of the application
    );
  }
}

// Home page widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Getting responsive values for button width and text style
    final buttonWidth = ResponsiveValues.buttonWidth(context);
    final textStyle = ResponsiveValues.textStyle(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white)), // Setting the title of the app bar
        backgroundColor:
            Theme.of(context).primaryColor, // Setting app bar background color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: const Key('transactButton'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransactScreen(
                            key: Key(
                                'transactScreen')))); // Navigating to transaction screen on button press
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(buttonWidth, 50), // Setting fixed button size
                textStyle: textStyle, // Applying responsive text style
              ),
              child: const Text("Transact"), // Button text
            ),
            const SizedBox(height: 50), // Adding space between buttons
            ElevatedButton(
              key: const Key('quitButton'),
              onPressed: () {
                SystemChannels.platform.invokeMethod(
                    'SystemNavigator.pop'); //  TODO: Make this behave the same in Windows platform
              }, // Close the application programmatically in Flutter's recommended way: using Navigator.pop(context) or Dart's exit(0) may cause bad behavior
              // Simply pop the context on quit, since this is guaranteed to be always at the root of the navigation stack
              style: ElevatedButton.styleFrom(
                fixedSize: Size(buttonWidth, 50), // Setting fixed button size
                textStyle: textStyle, // Applying responsive text style
              ),
              child: const Text("Quit"), // Button text
            ),
          ],
        ),
      ),
    );
  }
}
