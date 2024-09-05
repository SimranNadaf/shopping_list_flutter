import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/cotegory.dart';
const categories = {
  Categories.vegetables: Category(
    'Vegetables',
    Color.fromARGB(255, 0, 255, 128),
    Icons.eco,
  ),
  Categories.fruit: Category(
    'Fruit',
    Color.fromARGB(255, 145, 255, 0),
    Icons.apple,
  ),
  Categories.meat: Category(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
    Icons.restaurant,
  ),
  Categories.dairy: Category(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
    Icons.icecream,
  ),
  Categories.carbs: Category(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
    Icons.local_pizza,
  ),
  Categories.sweets: Category(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
    Icons.cake,
  ),
  Categories.spices: Category(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
    Icons.kitchen,
  ),
  Categories.convenience: Category(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
    Icons.fastfood,
  ),
  Categories.hygiene: Category(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
    Icons.cleaning_services,
  ),
  Categories.other: Category(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
    Icons.category,
  ),
};
