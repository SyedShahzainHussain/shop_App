import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_application_1/Provider/Cart.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";

import "Auth.dart";

class Order {
  final String? id;
  final DateTime? dateTime;
  final double? amount;
  final List<CartItem> product;

  Order({
    required this.id,
    required this.amount,
    required this.product,
    required this.dateTime,
  });
}

class OrderItem with ChangeNotifier {
  String token, userId;
  OrderItem(this.token, this._order, this.userId);
  List<Order> _order = [];
  List<Order> get order {
    return [..._order];
  }

  Future<void> addOrder(List<CartItem> cartproduct, double amount) async {
    final url =
        "https://flutter-shop-d4349-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token";
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          "amount": amount,
          "datetime": DateTime.now().toIso8601String(),
          'products': cartproduct
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList()
        }));
    _order.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        amount: amount,
        dateTime: DateTime.now(),
        product: cartproduct,
      ),
    );
    notifyListeners();
  }

  Future<void> getOrders() async {
    final url =
        "https://flutter-shop-d4349-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token";

    final response = await http.get(Uri.parse(url));
    print(jsonDecode(response.body));
    final List<Order> loadedProduct = [];
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data == null) {
      return;
    }
    data.forEach((key, value) {
      loadedProduct.add(Order(
          id: key,
          amount: value['amount'],
          product: (value['products'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'] as String,
                  title: e['title'] as String,
                  price: e['price'] as double,
                  quantity: e['quantity'] as int))
              .toList(),
          dateTime: DateTime.parse(value['datetime'] as String)));
    });

    _order = loadedProduct.reversed.toList();
    notifyListeners();
  }
}
