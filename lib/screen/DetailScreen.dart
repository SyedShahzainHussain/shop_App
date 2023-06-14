import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../Provider/Products.dart';
import 'DrawerScreen.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = "/detailScreem";

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments as String;
    var data = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      // appBar: AppBar(title: Text(data.title.toString())),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              title:  Text(data.title.toString(),style: TextStyle(color: Colors.cyan[100]),),
              centerTitle: true,
              background: Hero(
                tag: data.id.toString(),
                child: Image.network(
                  data.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${data.price}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 800,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
