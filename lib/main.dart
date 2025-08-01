import 'package:flutter/material.dart';
import 'database.dart'; // Import database
import 'shopping_item.dart'; // Import entity
import 'detail_page.dart'; // Import the new widget

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
  ShoppingItem? _selectedItem; // Holds the currently selected item

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final database = await $FloorAppDatabase.databaseBuilder('shopping_list.db').build();
    _dao = database.shoppingItemDao;
    _loadItems(); // Load items on startup
  }

  // Helper function to load/reload all items from the database
  Future<void> _loadItems() async {
    final itemList = await _dao?.findAllItems() ?? [];
    setState(() {
      _items.clear();
      _items.addAll(itemList);
    });
  }

  void _addItem() async {
    if (_itemController.text.trim().isNotEmpty && _qtyController.text.trim().isNotEmpty && _dao != null) {
      final newItem = ShoppingItem(
        name: _itemController.text.trim(),
        quantity: _qtyController.text.trim(),
      );
      await _dao!.insertItem(newItem);
      _itemController.clear();
      _qtyController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
      _loadItems(); // Reload the list to get the new item with its DB ID
    }
  }

  // Deletes the currently selected item
  void _deleteSelectedItem() async {
    if (_selectedItem != null && _dao != null) {
      await _dao!.deleteItem(_selectedItem!);
      setState(() {
        _selectedItem = null; // Clear selection
      });
      _loadItems(); // Refresh the list from the database
    }
  }

  // Handles item tap to show details
  void _handleItemTap(ShoppingItem item) {
    // Check if the screen is large (tablet/desktop)
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    setState(() {
      _selectedItem = item;
    });

    // navigate to a new page on small screens
    if (!isLargeScreen) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text(item.name)),
            body: DetailsPage(
              item: item,
              onDelete: () {
                _deleteSelectedItem();
                Navigator.of(context).pop(); // Go back after delete
              },
              onClose: () => Navigator.of(context).pop(), // Just go back
            ),
          ),
        ),
        // When detail page is closed, clear the selection
      ).then((_) => setState(() => _selectedItem = null));
    }
  }

  // Builds the list view widget
  Widget _buildListView() {
    return Expanded(
      child: _items.isEmpty
          ? const Center(child: Text("There are no items in the list"))
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, rowNum) {
          final item = _items[rowNum];
          return GestureDetector(
            // Change from onLongPress to onTap
            onTap: () => _handleItemTap(item),
            child: Card(
              color: _selectedItem?.id == item.id ? Colors.deepPurple.shade50 : null,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item.name}", style: const TextStyle(fontSize: 16)),
                    Text("Qty: ${item.quantity}", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder provides the constraints of the parent widget
    return LayoutBuilder(
      builder: (context, constraints) {
        // breakpoint for tablet
        final isLargeScreen = constraints.maxWidth > 600;

        return isLargeScreen
        // For large screens, use a Row with List and Details side-by-side
            ? Row(
          children: [
            // Master List Panel
            SizedBox(
              width: 350, // Fixed width for the list panel
              child: Column(
                children: [
                  _buildInputFields(),
                  const SizedBox(height: 10),
                  _buildListView(),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            // Details Panel
            Expanded(
              child: _selectedItem == null
                  ? const Center(child: Text("Select an item to see details"))
                  : DetailsPage(
                item: _selectedItem!,
                onDelete: _deleteSelectedItem,
                onClose: () => setState(() => _selectedItem = null),
              ),
            ),
          ],
        )
        // For small screens, show only the list and navigate on tap
            : Column(
          children: [
            _buildInputFields(),
            const SizedBox(height: 10),
            _buildListView(),
          ],
        );
      },
    );
  }

  // Extracted input fields into a helper widget for reuse
  Widget _buildInputFields() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _itemController,
              decoration: const InputDecoration(labelText: "Item", border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
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
    );
  }
}