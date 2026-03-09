import 'package:flutter/material.dart';
import 'food_model.dart';

class FoodCartModel extends ChangeNotifier {
  final List<FoodProduct> _items = [];

  List<FoodProduct> get items => _items;

  void add(FoodProduct product) {
    if (!_items.contains(product)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void remove(FoodProduct product) {
    _items.remove(product);
    notifyListeners();
  }

  bool isInCart(FoodProduct product) {
    return _items.contains(product);
  }

  int get count => _items.length;

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += double.parse(item.price.replaceAll("₹", ""));
    }
    return total;
  }
}
