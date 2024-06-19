import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'transact_form.dart';
import 'transact_checkout.dart';
import 'package:provider/provider.dart'; // Importing flutter's provider package
import '../supplies/supply_provider.dart';

var logger = Logger();

class TransactScreen extends StatefulWidget {
  const TransactScreen({super.key});

  @override
  State<TransactScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactScreen> {
  final List<Map<String, dynamic>> transactions = [];

  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Transact',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                icon: const Icon(Icons.shopping_cart_checkout_outlined,
                    color: Colors.white),
                onPressed: () {
                  transactCheckout(context, transactions);
                }),
          ]),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    setState(() {
                      transactions.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          transactions[index]["item"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quantity: ${transactions[index]["quantity"]}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              "Price: ${transactions[index]["price"]}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              "Total: ${transactions[index]["total"]}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Swipe to the left to delete.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          TransactionForm(
            transactionController: _transactionController,
            quantityController: _quantityController,
            addTransaction: _addTransaction,
          ),
        ],
      ),
    );
  }

  void _addTransaction() {
    final supplyProvider = Provider.of<SupplyProvider>(context, listen: false);
    final constructionSupplies = supplyProvider.constructionSupplies;

    final itemName = _transactionController.text;
    final quantityText = _quantityController.text;

    _transactionController.clear();
    _quantityController.clear();

    // Guard against empty fields
    if (itemName.isEmpty || quantityText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both fields.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // Guard against invalid quantities
    double? quantity = double.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amount cannot be zero or non-numeric.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // Fetch the supply ID based on the item name
    final supplyId = constructionSupplies.keys.firstWhere(
      (k) => constructionSupplies[k]?['supply_name'] == itemName,
      orElse: () =>
          -1, // Hacky way of sidestepping null-check, assuming supply_id is an int
    );

    // Null check
    if (supplyId == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item not found in the supply.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // Draft the final transaction
    final supplyData = constructionSupplies[supplyId];
    final price = supplyData!['price'] as double;
    final newTransaction = {
      "id": supplyId, // Actual supplyId
      "item": itemName,
      "quantity": double.parse(quantityText),
      "price": price,
      "total": price * double.parse(quantityText),
    };

    // Append transaction to internal transaction array
    setState(() {
      transactions.add(newTransaction);
    });

    // Scroll down to bottom of the transaction list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    logger.d(transactions);
  }
}
