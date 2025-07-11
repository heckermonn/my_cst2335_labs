import 'package:flutter/material.dart';

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
        body: ListPage(),
      ),
    );
  }
}

class ShoppingItem {
  String name;
  String quantity;

  ShoppingItem(this.name, this.quantity);
}

Widget ListPage() {
  return const ShoppingListBody();
}

class ShoppingListBody extends StatefulWidget {
  const ShoppingListBody({super.key});

  @override
  State<ShoppingListBody> createState() => _ShoppingListBodyState();
}

class _ShoppingListBodyState extends State<ShoppingListBody> {
  final List<ShoppingItem> _items = [];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  void _addItem() {
    setState(() {
      if (_itemController.text.trim().isNotEmpty &&
          _qtyController.text.trim().isNotEmpty) {
        _items.add(ShoppingItem(
          _itemController.text.trim(),
          _qtyController.text.trim(),
        ));
        _itemController.text = "";
        _qtyController.text = "";
      }
    });
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
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              setState(() {
                _items.removeAt(index);
              });
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
        // Input Row
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                    labelText: "Item",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _qtyController,
                  decoration: const InputDecoration(
                    labelText: "Qty",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              ElevatedButton(
                onPressed: _addItem,
                child: const Text("Add"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // List Section
        Expanded(
          child: _items.isEmpty
              ? const Center(
            child: Text("There are no items in the list"),
          )
              : ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, rowNum) {
              final item = _items[rowNum];
              return GestureDetector(
                onLongPress: () => _confirmDelete(rowNum),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${rowNum + 1}. ${item.name}"),
                      Text("Qty: ${item.quantity}"),
                    ],
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
