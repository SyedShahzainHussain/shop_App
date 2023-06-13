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
      appBar: AppBar(title: Text(data.id.toString())),
      body: Column(
        children: [
         Container(
          height: 300,
          width: double.infinity,
          child: Image.network(
            data.image,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 10,),
        Text('\$${data.price}',style: TextStyle(color: Colors.grey,fontSize: 20),),
        SizedBox(height: 10,),


        ],
      ),
    );
  }
}
