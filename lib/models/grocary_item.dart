import 'package:shopping_list_app/models/cotegory.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.unit,
  });

  final String id;
  final String name;
  final int quantity;
  final Category category;
  final String unit;
}
