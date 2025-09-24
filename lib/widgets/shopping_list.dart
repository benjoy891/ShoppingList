import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<GroceryItem> _groceryItem = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'flutter-prep-2bea8-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    try {
      final response = await http.get(url);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data. Please try again later.";
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
            )
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value["quantity"],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItem = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = "Failed to fetch data. Please try again later.";
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => NewItemScreen()));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItem.add(newItem);
    });
  }

  void _onRemoveItem(GroceryItem newItem) async {
    final index = _groceryItem.indexOf(newItem);
    setState(() {
      _groceryItem.remove(newItem);
    });
    final url = Uri.https(
      'flutter-prep-2bea8-default-rtdb.firebaseio.com',
      'shopping-list/${newItem.id}.json',
    );
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItem.insert(index, newItem);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: const Text("Could not delete item. Try again later."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: const Text("Item deleted"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "No items added yet",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItem.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItem.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItem[index].id),
          background: Container(
            color: const Color.fromARGB(255, 236, 204, 156),
          ),
          child: ListTile(
            title: Text(_groceryItem[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItem[index].category.color,
            ),
            trailing: Text(_groceryItem[index].quantity.toString()),
          ),
          onDismissed: (direction) => _onRemoveItem(_groceryItem[index]),
        ),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!, style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
