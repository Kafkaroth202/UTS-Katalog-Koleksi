import 'package:flutter/material.dart';
import '../helper/database_helper.dart';
import '../models/item.dart';

// Temporary screen for Phase 2: only proves the database works.
// It is replaced by the card grid in Phase 3.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await DatabaseHelper.instance.getItems();
    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Collection Catalog (${_items.length})')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text('${item.type} • ${item.status}'),
          );
        },
      ),
    );
  }
}
