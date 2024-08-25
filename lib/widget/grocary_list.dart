import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocary_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GrocaryList extends StatefulWidget {
  const GrocaryList({super.key});

  @override
  State<GrocaryList> createState() => _GrocaryListState();
}

class _GrocaryListState extends State<GrocaryList> {
  // List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _loadedItems;

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadList();
  }

// runs only once though build run multiple times - don't add or remove item
  Future<List<GroceryItem>> _loadList() async {
    final url = Uri.https(
        'shopping-list-app-flutte-ea3cf-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception("Fail to Fetch data, Please Try again later!");
    }
    if (response.body == 'null') {
      return [];
    }
    List<GroceryItem> loaditems = [];
    final Map<String, dynamic> items = json.decode(response.body);
    for (final item in items.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      loaditems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    return loaditems;
  }

  void _addItem() async {
    // final item = await Navigator.of(context).push<GroceryItem>(
    //   MaterialPageRoute(
    //     builder: (ctx) => const NewItem(),
    //   ),
    // );
    // setState(() {
    //   _loadedItems.add(item!);
    // });
  }

  void removeItem(GroceryItem item) async {
    // final index = _groceryItems.indexOf(item);
    // setState(() {
    //   _groceryItems.remove(item);
    // });
    // final url = Uri.https(
    //     'shopping-list-app-flutte-ea3cf-default-rtdb.asia-southeast1.firebasedatabase.app',
    //     'shopping-list/${item.id}.json');
    // final response = await http.delete(url);
    // if (response.statusCode >= 400) {
    //   setState(() {
    //     _groceryItems.insert(index, item);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _loadedItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error!.toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.red,
                      ),
                ),
              );
            }
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No Items Added yet!",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(snapshot.data![index].id),
                onDismissed: (direction) {
                  removeItem(snapshot.data![index]);
                },
                child: ListTile(
                  title: Text(snapshot.data![index].name),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: snapshot.data![index].category.color,
                  ),
                  trailing: Text(snapshot.data![index].quantity.toString()),
                ),
              ),
            );
          }),
    );
  }
}
