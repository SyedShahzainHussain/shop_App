import "package:flutter/material.dart";
import "package:flutter_application_1/Provider/Products.dart";
import "package:flutter_application_1/screen/DrawerScreen.dart";
import "package:provider/provider.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "EditProductScreen.dart";
import "UserProductItem.dart";

class UserProductScreen extends StatelessWidget {
  static const routeName = 'userProductScreen';
  const UserProductScreen({super.key});

  Future<void> _refreshIndicator(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).getProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // var productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      drawer: DrawerScreen(),
      body: FutureBuilder(
        future: _refreshIndicator(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitFadingCircle(
              color: Colors.blueAccent,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () => _refreshIndicator(context),
              color: Colors.white,
              backgroundColor: Colors.black,
              child: Consumer<Products>(
                builder: (context, productData, _) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            UserProductItem(
                              id: productData.items[index].id,
                              title: productData.items[index].title,
                              imageUrl: productData.items[index].image,
                            ),
                            Divider(),
                          ],
                        );
                      },
                      itemCount: productData.items.length,
                    ),
                  );
                },
              ),
            );
          } else {
            return SpinKitFadingCircle(
              color: Colors.blueAccent,
            );;
          }
        },
      ),
    );
  }
}
