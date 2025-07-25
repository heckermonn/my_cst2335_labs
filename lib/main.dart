import 'package:flutter/material.dart';
import 'database.dart'; // Import database
import 'shopping_item.dart'; // Import entity

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping List'),
          backgroundColor: Colors.deepPurple.shade100,
        ),
        body: const ListPage(),
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<ShoppingItem> _items = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  ShoppingItemDao? _dao;

  @override
  void initState() {
    super.initState();
    // Initialize the database and load existing items
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    // Build the database instance
    final database = await $FloorAppDatabase.databaseBuilder('shopping_list.db').build();
    _dao = database.shoppingItemDao;

    // Load all items from the database on startup
    final itemList = await _dao!.findAllItems();
    setState(() {
      _items.addAll(itemList);
    });
  }

  //Adds item to the list and INSERTS into the database
  void _addItem() async {
    if (_itemController.text.trim().isNotEmpty && _qtyController.text.trim().isNotEmpty && _dao != null) {
      final newItem = ShoppingItem(
        ShoppingItem.ID, // Use the static ID counter
        _itemController.text.trim(),
        _qtyController.text.trim(),
      );

      await _dao!.insertItem(newItem); // Insert into DB
      setState(() {
        _items.add(newItem); // Add to local list
        _itemController.text = "";
        _qtyController.text = "";
      });
    }
  }

  //DELETES the item from the database
  void _deleteItem(int index) async {
    if (_dao != null) {
      final itemToDelete = _items[index];
      await _dao!.deleteItem(itemToDelete); // Delete from DB
      setState(() {
        _items.removeAt(index); // Remove from local list
      });
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Item?"),
        content: const Text("Do you want to delete this item?"),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              _deleteItem(index);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(labelText: "Item", border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _qtyController,
                  decoration: const InputDecoration(labelText: "Qty", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addItem,
                child: const Text("Add"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        //List is loaded from database on startup
        Expanded(
          child: _items.isEmpty
              ? const Center(child: Text("There are no items in the list"))
              : ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, rowNum) {
              final item = _items[rowNum];
              return GestureDetector(
                onLongPress: () => _confirmDelete(rowNum),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${rowNum + 1}. ${item.name}", style: const TextStyle(fontSize: 16)),
                        Text("Qty: ${item.quantity}", style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}