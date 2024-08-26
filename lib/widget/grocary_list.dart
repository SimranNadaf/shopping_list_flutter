import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/widget/new_item.dart';
import 'package:shopping_list_app/models/grocary_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GrocaryList extends StatefulWidget {
  const GrocaryList({super.key});

  @override
  State<GrocaryList> createState() => _GrocaryListState();
}

class _GrocaryListState extends State<GrocaryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  void _loadList() async {
    final url = Uri.https(
        'shopping-list-app-flutte-ea3cf-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = "Fail to Fetch data, Please Try again later!";
          _isLoading = false;
        });
        return;
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
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
      setState(() {
        _groceryItems = loaditems;
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _error = "Sometihing went wrong, Please Try again later!";
        _isLoading = false;
      });
    }
  }

  void _addItem() async {
    final item = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    setState(() {
      _groceryItems.add(item!);
    });
    if(context.mounted){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item added successfully!")));
    }
    }

  void removeItem(GroceryItem item) async {
    
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item Deleted successfully!")));
    final url = Uri.https(
        'shopping-list-app-flutte-ea3cf-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400 && context.mounted) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fail to delete item. Please try again later!")));
    
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "No Items Added yet!",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );

    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.red,
              ),
        ),
      );
    }

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          background: Container(
            color: Colors.red,
            child: const Padding(padding: 
             EdgeInsets.fromLTRB(2,2,2,2),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete),
                Text("Deleting..."),
              ],
            ),),
          ),
          confirmDismiss: (direction) =>
          showDialog(context: context, builder: (ctx)=> AlertDialog(title: const Text("Please Confirm"),content: const Text("Are you sure to delete item?"),
        actions: [TextButton(onPressed: () {
        Navigator.of(context).pop(false);
        }, child: const Text("No"),), TextButton(onPressed: (){  Navigator.of(context).pop(true);}, child: const Text("Yes"),)],),),

          onDismissed: (direction) {
            removeItem(_groceryItems[index]);
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _groceryItems[index].category.color,
              ),
              width: 24,
              height: 24,
              // color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

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
      body: content,
    );
  }
}
