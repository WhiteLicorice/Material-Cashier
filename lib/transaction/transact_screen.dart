import 'package:flutter/material.dart';

// Define a StatefulWidget for the TransactScreen
class TransactScreen extends StatefulWidget {
  const TransactScreen({Key? key}) : super(key: key);

  @override
  State<TransactScreen> createState() => _TransactionScreenState();
}

// Define the State class associated with TransactScreen
class _TransactionScreenState extends State<TransactScreen> {
  // Initialize a list of transactions with dummy data
  final List<Map<String, dynamic>> transactions = List.generate(10, (index) {
    return {
      "id": index,
      "title": "Transaction #$index",
      "amount": (index + 1) * 10
    };
  });

  // Initialize controllers for text input fields
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transact'),
      ),
      body: Column(
        children: [
          // Expanded ListView to display transactions
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, index) {
                // Dismissible widget to enable swiping to delete
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
                  // Card widget to display each transaction
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(transactions[index]["id"].toString()),
                      ),
                      title: Text(transactions[index]["title"]),
                      subtitle: Text(transactions[index]["amount"].toString()),
                      trailing: const Icon(Icons.arrow_back),
                    ),
                  ),
                );
              },
            ),
          ),
          // Transaction input form
          _buildTransactionForm(),
        ],
      ),
    );
  }

  // Function to build the transaction input form
  Widget _buildTransactionForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Text input field for transaction title
          Expanded(
            child: TextFormField(
              controller: _transactionController,
              decoration: const InputDecoration(
                labelText: 'Transaction',
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Text input field for transaction amount
          Expanded(
            child: TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          // Button to add the transaction
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _addTransaction,
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  // Function to add a new transaction
  void _addTransaction() {
    final transactionTitle = _transactionController.text;
    final quantityText = _quantityController.text;
    if (transactionTitle.isNotEmpty && quantityText.isNotEmpty) {
      // Create a new transaction object and add it to the list
      final newTransaction = {
        "id": transactions.length,
        "title": transactionTitle,
        "amount": int.parse(quantityText),
      };
      setState(() {
        transactions.add(newTransaction);
      });
      // Clear input fields after adding transaction
      _transactionController.clear();
      _quantityController.clear();
    } else {
      // Show an error message if input fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both fields.'),
        ),
      );
    }
  }
}
