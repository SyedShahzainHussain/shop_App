import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../Models/Product.dart";
import "../Provider/Products.dart";
import "ProductItem.dart";

class Gridview extends StatelessWidget {
  final bool showFavorite;
  Gridview(this.showFavorite);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Products>(context);
    var product = showFavorite ? data.favoriteItems : data.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, i) =>
          ChangeNotifierProvider.value(value: product[i], child: ProductItem()),
      itemCount: product.length,
    );
  }
}
