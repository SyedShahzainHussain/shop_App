import "package:flutter/material.dart";
import "package:flutter_application_1/Provider/Cart.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:provider/provider.dart";

import "../Provider/Cart.dart" show Cart;
import "../Provider/Order.dart";
import "./CartItem.dart" as ors;

class CartScreen extends StatelessWidget {
  static const routeName = 'cartScreen';
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final or = Provider.of<OrderItem>(context,listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Chip(
                        label: Text(
                          '${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      NewWidget(cart: cart, or: or),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ors.CartItem(
                      id: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity,
                      title: cart.items.values.toList()[index].title,
                    );
                  },
                  itemCount: cart.items.length,
                ),
              ),
            ],
          ),
        ));
  }
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    super.key,
    required this.cart,
    required this.or,
  });

  final Cart cart;
  final OrderItem or;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
    return TextButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await widget.or.addOrder(
                    widget.cart.items.values.toList().cast<CartItem>(),
                    widget.cart.totalAmount);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              },
        child:  _isLoading ? SpinKitFadingCircle() : const  Text("Order Now"));
  }
}
