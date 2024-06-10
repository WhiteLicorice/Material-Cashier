import 'package:flutter/material.dart';
import '../utils/_responsive_values.dart'; // Importing utility functions related to responsiveness
import 'package:brm_cashier/transaction/transact_screen.dart'; // Importing a screen for transaction functionality
import 'package:flutter/services.dart'; // Importing Flutter's services library for controlling system-level events

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
                    'SystemNavigator.pop'); // Close the application programmatically
              },
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
