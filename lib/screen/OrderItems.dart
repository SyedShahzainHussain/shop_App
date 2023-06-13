import "dart:math";

import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import "../Provider/Order.dart";

class OrderItems extends StatefulWidget {
  final Order order;
  OrderItems(this.order);

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toString()}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime!),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              child: Container(
                height: min(widget.order.product.length * 20.0 + 10, 100),
                child: ListView(
                  children: widget.order.product.map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.title.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                          Text('${e.quantity}x \$${e.price}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                        ],
                      )).toList(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
