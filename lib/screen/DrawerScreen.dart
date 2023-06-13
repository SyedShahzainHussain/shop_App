import "package:flutter/material.dart";

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [

            AppBar(title:Text('Hello Friends') ,automaticallyImplyLeading: false,),
            Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              title: Text('Shop'),
              trailing: Icon(Icons.shop),
            ),
            ListTile(
               onTap: () {
                Navigator.of(context).pushReplacementNamed('orderScreen');
              },
              title: Text('Order'),
              trailing: Icon(Icons.payment),
            ),
            ListTile(
               onTap: () {
                Navigator.of(context).pushReplacementNamed('userProductScreen');
              },
              title: Text('Edit'),
              trailing: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
