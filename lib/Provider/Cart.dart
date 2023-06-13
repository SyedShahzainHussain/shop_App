import 'package:flutter/material.dart';

class CartItem {
  final String? id;
  final String? title;
  final double? price;
  final int? quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, dynamic> _items = {};

  Map<String, dynamic> get items {
    return {..._items};
  }

  int get itemCount {
    int totalQuantity = 0;
    _items.forEach((key, cartItem) {
      totalQuantity += cartItem.quantity as int;
    });

    return totalQuantity;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  // ignore: non_constant_identifier_names
  void addItem(String ProductId, String title, double price) {
    if (_items.containsKey(ProductId)) {
      _items.update(
          ProductId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          ProductId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String ProductId) {
    if (!_items.containsKey(ProductId)) {
      return;
    }
    if (_items[ProductId].quantity > 1) {
      _items.update(
          ProductId,
          (existingVal) => CartItem(
              id: existingVal.id,
              title: existingVal.title,
              price: existingVal.price,
              quantity: existingVal.quantity - 1));
    } else {
      _items.remove(ProductId);
    }
    notifyListeners();
  }
}
