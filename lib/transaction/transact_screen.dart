import 'package:flutter/material.dart';
import 'transact_form.dart';

// TransactScreen is a StatefulWidget which represents the main screen of the app
class TransactScreen extends StatefulWidget {
  const TransactScreen({super.key});

  @override
  State<TransactScreen> createState() => _TransactionScreenState();
}

// State class for TransactScreen
class _TransactionScreenState extends State<TransactScreen> {
  //  TODO: Blank out in prod
  // Initialize a list of transactions with dummy data
  final List<Map<String, dynamic>> transactions = List.generate(10, (index) {
    return {
      "id": index,
      "item": "Dummy #$index",
      "quantity": (index + 1),
      "price": 10,
      "total": (index + 1) * 10
    };
  });

  // Controllers for transaction input fields
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  //  TODO: Change this into an API call to retrieve supplies
  // Mock dictionary of construction supplies and their prices
  final Map<String, double> _constructionSupplies = {
    'Cement': 100.0,
    'Sand': 50.0,
    'Gravel': 70.0,
    'Bricks': 30.0,
    'Steel': 200.0,
    'Cement Mix': 120.0,
    'Concrete': 150.0,
    'Sanding Paper': 20.0,
    'Gravel Stones': 80.0,
    'Brick Tiles': 40.0,
    'Brick Blocks': 45.0,
    'Steel Rods': 210.0,
    'Steel Beams': 220.0,
    'Wood': 60.0,
    'Wooden Planks': 65.0,
    'Plywood': 55.0,
    'Nails': 10.0,
    'Screws': 15.0,
    'Bolts': 25.0,
    'Washers': 5.0,
    'Concrete Mix': 160.0,
    'Cement Bags': 110.0,
    'Mortar': 90.0,
    'Asphalt': 130.0,
    'Insulation': 85.0,
    'Paint': 75.0,
    'Primer': 35.0,
    'Varnish': 45.0,
    'Tile Adhesive': 70.0,
    'Floor Tiles': 95.0,
    'Wall Tiles': 100.0,
    'Roof Tiles': 105.0,
    'Ceramic Tiles': 115.0,
    'Marble': 140.0,
    'Granite': 145.0,
    'Slate': 150.0,
    'Gypsum': 50.0,
    'Plaster': 55.0,
    'Drywall': 60.0,
    'PVC Pipes': 30.0,
    'Copper Pipes': 35.0,
    'Pex Pipes': 40.0,
    'Electrical Wires': 20.0,
    'Switches': 15.0,
    'Outlets': 10.0,
    'Circuit Breakers': 25.0,
    'Light Fixtures': 35.0,
    'LED Bulbs': 5.0,
    'Fluorescent Tubes': 10.0,
    'Glass Panels': 45.0,
    'Window Frames': 50.0,
    'Door Frames': 55.0,
    'Locks': 20.0,
    'Hinges': 15.0,
    'Handles': 10.0,
  };

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
                            transactions[index]["id"].toString(),
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
                            // Your delete function here
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Transaction input form
          TransactionForm(
            transactionController: _transactionController,
            quantityController: _quantityController,
            addTransaction: _addTransaction,
            constructionSupplies: _constructionSupplies,
          ),
        ],
      ),
    );
  }

  // Function to add a new transaction to the list
  void _addTransaction() {
    final itemName = _transactionController.text;
    final quantityText = _quantityController.text;

    // Clear input fields after fetching the transaction
    _transactionController.clear();
    _quantityController.clear();

    if (itemName.isNotEmpty && quantityText.isNotEmpty) {
      // Create a new transaction object and add it to the list
      final newTransaction = {
        "id": transactions.length,
        "item": itemName,
        "quantity": double.parse(quantityText),
        "price": _constructionSupplies[itemName]!,
        "total": _constructionSupplies[itemName]! * double.parse(quantityText),
      };
      setState(() {
        transactions.add(newTransaction);
      });
      print(transactions);
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
