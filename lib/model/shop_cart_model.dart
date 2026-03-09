import 'package:flutter/material.dart';
import 'shop_product_model.dart';

class ShopCartModel extends ChangeNotifier {
  final List<ShopProduct> _items = [];

  List<ShopProduct> get items => _items;

  void add(ShopProduct product) {
    if (!_items.contains(product)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void remove(ShopProduct product) {
    _items.remove(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(ShopProduct product) {
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
