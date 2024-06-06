import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TransactionForm extends StatelessWidget {
  final TextEditingController transactionController;
  final TextEditingController quantityController;
  final void Function() addTransaction;
  final Map<String, double> constructionSupplies;

  const TransactionForm({
    super.key,
    required this.transactionController,
    required this.quantityController,
    required this.addTransaction,
    required this.constructionSupplies,
  });

  @override
  Widget build(BuildContext context) {
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
                // pattern = transactionController.text;
                // print(pattern);
                if (pattern.length > 1) {
                  return constructionSupplies.keys
                      .where((supply) =>
                          supply.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                }
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
