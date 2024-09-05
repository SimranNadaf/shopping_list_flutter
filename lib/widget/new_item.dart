import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/cotegory.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/models/grocary_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final items = ["KG", "GM", "Ltr", "ml", "Pcs"];
  final _formkey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQnt = 1;
  var _selectedCategory = categories[Categories.vegetables];
  var isSending = false;
  var _selectedUnit = "KG";

  void _addItem() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      setState(() {
        isSending = true;
      });
      final url = Uri.https(
          'shopping-list-app-flutte-ea3cf-default-rtdb.asia-southeast1.firebasedatabase.app',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": _enteredName,
          "quantity": _enteredQnt,
          "category": _selectedCategory!.title,
          "unit": _selectedUnit,
        }),
      );
      final Map<String, dynamic> item = json.decode(response.body);
      if (context.mounted) {
        Navigator.of(context).pop(GroceryItem(
          id: item['name'],
          name: _enteredName,
          quantity: _enteredQnt,
          category: _selectedCategory!,
          unit: _selectedUnit,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be Between 2 to 50 length!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 70,
                    child: Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        initialValue: _enteredQnt.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a Valid, Positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredQnt = int.tryParse(value!)!;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 84,
                    child: Expanded(
                      child: DropdownButtonFormField(
                          value: _selectedUnit,
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _selectedUnit = value!;
                          }),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  // Container(
                                  //     height: 16,
                                  //     width: 16,
                                  //     color: category.value.color),
                                  Icon(
                                    category.value.icon,
                                    color: category.value.color,
                                  ),

                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(category.value.title),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            _formkey.currentState!.reset();
                          },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _addItem,
                    child: isSending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add Item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
