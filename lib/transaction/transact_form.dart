import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:provider/provider.dart'; //  Importing flutter's provider package
import '../supplies/supply_provider.dart';

class TransactionForm extends StatelessWidget {
  final TextEditingController transactionController;
  final TextEditingController quantityController;
  final void Function() addTransaction;

  const TransactionForm({
    super.key,
    required this.transactionController,
    required this.quantityController,
    required this.addTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final supplyProvider = Provider.of<SupplyProvider>(context, listen: false);
    final constructionSupplies = supplyProvider.constructionSupplies;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TypeAheadField<String>(
              direction: VerticalDirection.up,
              controller: transactionController,
              hideOnEmpty: true,
              builder: (context, controller, focusNode) {
                return TextField(
                    controller: transactionController,
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Item',
                    ));
              },
              suggestionsCallback: (pattern) {
                if (pattern.length > 1) {
                  return constructionSupplies.keys
                      .where((supply) =>
                          supply.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                }
                return [];
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSelected: (suggestion) {
                print("Selected $suggestion");
                transactionController.text = suggestion;
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: addTransaction,
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
