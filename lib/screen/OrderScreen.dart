import "package:flutter/material.dart";
import "package:flutter_application_1/Provider/Order.dart";
import "package:provider/provider.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:shimmer/shimmer.dart";

import "./OrderItems.dart";
import "DrawerScreen.dart";

class OrderScreen extends StatefulWidget {
  static const routeName = 'orderScreen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _OrdersFuture;
  Future _obtainFuture() {
    return Provider.of<OrderItem>(context, listen: false).getOrders();
  }

  @override
  void initState() {
    _OrdersFuture = _obtainFuture();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderItem>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: DrawerScreen(),
      body: FutureBuilder(
          future: _OrdersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.grey.shade100,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        color: Colors.grey,
                      ),
                    ),
                  ));
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Text("No Orders Found"),
              );
            } else if (snapshot.error != null) {
              return Center(
                child: Text('No Orders Found'),
              );
            } else {
              return ListView.builder(
                itemBuilder: (ctx, i) => OrderItems(
                  orders.order[i] as Order,
                ),
                itemCount: orders.order.length,
              );
            }
          }),
    );
  }
}


// Shimmer.fromColors(
//               baseColor: Colors.grey,
//               highlightColor: Colors.grey.shade100,
//               child: ListView.builder(
//                 itemCount: 10,
//                 itemBuilder: (ctx,index)=> Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Container(
//                     width: double.infinity,
//                     height: 70,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ))