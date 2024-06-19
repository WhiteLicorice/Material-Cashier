import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

var logger = Logger();

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

  // If the cashier confirms and confirm == true, proceed with the transaction
  if (confirm == true) {
    try {
      //  Fetch a unique user id
      var uuid = const Uuid();
      String transactionHash = uuid.v4();

      //  Insert transaction hash -> use transaction hash as foreign key when inserting into transaction_items
      final response =
          await Supabase.instance.client.from('transactions').insert(
        {
          'transaction_hash': transactionHash,
        },
      ).select();

      logger.d(response);

      for (var transaction in transactions) {
        await Supabase.instance.client.from('transaction_items').insert({
          'item_id': transaction[
              'id'], // Using the actual supply_id, see transact_form
          'quantity': transaction['quantity'],
          'transaction_hash': transactionHash,
        });
      }

      // If successful, navigate to the home page
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (error) {
      // Handle any errors
      if (context.mounted) {
        logger.d('Error during transaction: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction failed: $error'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
