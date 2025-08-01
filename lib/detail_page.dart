import 'package:flutter/material.dart';
import 'shopping_item.dart'; // Import entity

class DetailsPage extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const DetailsPage({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Item Details", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            Text("Database ID: ${item.id}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Name: ${item.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Quantity: ${item.quantity}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                  onPressed: onClose,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}