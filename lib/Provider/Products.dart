import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

import '../Models/Product.dart';
import 'Auth.dart';

class Products with ChangeNotifier {
  List<Product> _item = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   price: 29.99,
    //   image:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   price: 59.99,
    //   image:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   price: 19.99,
    //   image: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   price: 49.99,
    //   image:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String token, userId;
  Products(this.token, this._item, this.userId);

  List<Product> get items {
    return [..._item];
  }

  Product findById(String productId) {
    return _item.firstWhere((element) => element.id == productId);
  }

  List<Product> get favoriteItems {
    return _item.where((element) => element.isFavorite).toList();
  }

  Future<void> getProduct(BuildContext context) async {
    var url =
        "https://flutter-shop-d4349-default-rtdb.firebaseio.com/products.json?auth=$token";
    try {
      final response = await http.get(Uri.parse(url));
      var data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      url =
          "https://flutter-shop-d4349-default-rtdb.firebaseio.com/favorite/$userId.json?auth=$token";
      final favoritesREsponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoritesREsponse.body);
      final List<Product> loadedProduct = [];

      data.forEach((key, value) {
        loadedProduct.add(Product(
            id: key,
            title: value['title'].toString(),
            image: value['image'].toString(),
            price: value['price'],
            isFavorite: favoriteData == null ? false :  favoriteData[key]?? false));
      });
      _item = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addProduct(Product product, BuildContext context) async {
    final url =
        "https://flutter-shop-d4349-default-rtdb.firebaseio.com/products.json?auth=$token";
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'image': product.image,
          }));

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        image: product.image,
        price: product.price,
      );
      _item.add(newProduct);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatedProduct(String id, Product newProduct) async {
    final proIndex = _item.indexWhere((element) => element.id == id);
    if (proIndex >= 0) {
      final url =
          "https://flutter-shop-d4349-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
      await http.patch(Uri.parse(url),
          body: json.encode({
            "title": newProduct.title,
            "price": newProduct.price,
            "image": newProduct.image,
          }));
      _item[proIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> remove(String id) async {
    final url =
        "https://flutter-shop-d4349-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
    final existingProductIndex =
        _item.indexWhere((element) => element.id == id);
    var existingProduct = _item[existingProductIndex];
    _item.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _item.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null!;
  }
}
