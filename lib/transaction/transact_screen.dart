import 'package:flutter/material.dart';
import '../utils/_responsive_values.dart';

class TransactScreen extends StatelessWidget {
  const TransactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final double buttonSize = ResponsiveValues.buttonWidth(context);

    // Mock transactions array
    List<String> transactions = [
      'Transaction 1',
      'Transaction 2',
      'Transaction 3',
      'Transaction 4',
      'Transaction 5',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transact'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              //  TODO: Add search functionality here
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.5, // 50% of the screen width
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(transactions[index]),
                //  TODO: Add other transaction details here if needed
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  TODO: Add checkout functionality here
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
