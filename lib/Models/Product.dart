import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String image;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.image,
      required this.price,
      this.isFavorite = false});

  Future<void> favoriteToggle(String token,String userId) async {

    final oldFavorite = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        "https://flutter-shop-d4349-default-rtdb.firebaseio.com/favorite/$userId/$id.json?auth=$token";
    try {
      await http.put(Uri.parse(url),
          body: json.encode(
           isFavorite,
          ));
    } catch (_) {
      isFavorite = oldFavorite;
    }
  }
}
