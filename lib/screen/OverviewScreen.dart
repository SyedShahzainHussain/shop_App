import "package:flutter/material.dart";
import "package:flutter_application_1/Provider/Products.dart";
import "package:provider/provider.dart";
import "package:shimmer/shimmer.dart";

import "../Provider/Cart.dart";
import "Bedge.dart";
import "CartScreen.dart";
import "DrawerScreen.dart";
import "Gridview.dart";

enum FileterOption {
  Favorites,
  All,
}

class OverviewScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  var _isLoading = true;
  var _isint = true;
  @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((value) =>
  //       Provider.of<Products>(context,)
  //           .getProduct()
  //           .then((value) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }));
  //   // TODO: implement initState
  //   super.initState();
  // }

  void didChangeDependencies() {
    if (_isint) {
      Provider.of<Products>(context).getProduct(context).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isint = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  bool? _showFavotiteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FileterOption value) {
              setState(() {
                if (value == FileterOption.Favorites) {
                  _showFavotiteOnly = true;
                } else {
                  _showFavotiteOnly = false;
                }
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FileterOption.Favorites,
                child: Text('Only Favorites'),
              ),
              PopupMenuItem(
                value: FileterOption.All,
                child: Text('Show All'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, value, child) => Bedge(
              color: Colors.red,
              value: value.itemCount.toString(),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                  )),
            ),
          )
        ],
      ),
      drawer: DrawerScreen(),
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade500,
              highlightColor: Colors.grey.shade100,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (ctx, i) => Column(
                  children: [
                    ListTile(
                      title: Container(
                        width: 89,
                        height: 10,
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        width: 89,
                        height: 10,
                        color: Colors.white,
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ))
          : Gridview(_showFavotiteOnly!),
    );
  }
}
