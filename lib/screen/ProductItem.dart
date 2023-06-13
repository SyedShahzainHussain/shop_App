import "package:flutter/material.dart";
import "package:flutter_application_1/Provider/Auth.dart";
import "package:flutter_application_1/Provider/Cart.dart";
import "package:provider/provider.dart";
import "./DetailScreen.dart";
import "../Models/Product.dart";

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var _showFovite = false;
  @override
  Widget build(BuildContext context) {
    print(_showFovite);
    final data = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(
            data.title,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: Consumer<Product>(
            builder: (ctx, prod, child) => IconButton(
              onPressed: () {
                if (prod.isFavorite == true) {
                  setState(() {
                    _showFovite = true;
                  });
                } else {
                  setState(() {
                    _showFovite = false;
                  });
                }
                prod.favoriteToggle(auth.token!,auth.userId);
              },
              icon: Icon(
                prod.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.deepOrange.shade400,
              ),
            ),
          ),
          trailing: IconButton(
              onPressed: () {
                cart.addItem(
                    data.id.toString(), data.title.toString(), data.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Add To Cart',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                  action: SnackBarAction(
                      label: "UNDO",
                      textColor: Colors.red,
                      onPressed: () {
                        cart.removeSingleItem(data.id.toString());
                      }),
                ));
              },
              icon:
                  Icon(Icons.shopping_cart, color: Colors.deepOrange.shade400)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              DetailScreen.routeName,
              arguments: data.id,
            );
          },
          child: Image.network(
            data.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
