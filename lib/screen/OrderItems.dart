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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _expanded
            ? min(
                widget.order.product.length * 24 + 110,
                MediaQuery.of(context).size.height * 0.6,
              )
            : 95,
        child: Card(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text('\$${widget.order.amount!.toStringAsFixed(2)}'),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: Container(
                        height: _expanded
                            ? min(
                                widget.order.product.length * 22.0,
                                MediaQuery.of(context).size.height * 0.3,
                              )
                            : 0,
                        child: ListView(
                          children: widget.order.product
                              .map((e) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e.title.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text('${e.quantity}x \$${e.price}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
