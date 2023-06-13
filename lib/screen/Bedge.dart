import 'package:flutter/material.dart';

class Bedge extends StatelessWidget {
  final Color color;
  final Widget child;
  final String value;
  Bedge(
      {super.key,
      required this.color,
      required this.child,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: color,
              ),
              constraints: BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ))
      ],
    );
  }
}
