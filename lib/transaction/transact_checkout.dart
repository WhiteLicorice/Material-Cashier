import 'package:flutter/material.dart';

Future<void> transactCheckout(
    BuildContext context, List<Map<String, dynamic>> transactions) async {
  // Calculate the total price of the items
  double totalPrice = transactions.fold(0, (sum, item) => sum + item['total']);

  // If total price is zero, show empty cart prompt
  if (totalPrice == 0) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Cart',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('There are no items in the cart.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  // Show a dialog with the total price
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Checkout'),
        content: Text.rich(
          TextSpan(
            text: 'The total price of the items is ',
            style: const TextStyle(fontWeight: FontWeight.normal),
            children: <TextSpan>[
              TextSpan(
                text: '₱${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: '.',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ],
      );
    },
  );

  // If the cashier confirms and confirm == true, navigate to the home page
  if (confirm == true && context.mounted) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
