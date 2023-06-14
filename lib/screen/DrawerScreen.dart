import "package:flutter/material.dart";
import "package:flutter_application_1/screen/OrderScreen.dart";
import "package:provider/provider.dart";

import "../Provider/Auth.dart";
import "../helpers/custom_routes.dart";

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Auth?>(context);
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            AppBar(
              title: Text('Hello Friends'),
              automaticallyImplyLeading: false,
            ),
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
                // Navigator.of(context).pushReplacement(CustomRoute(
                //   builder: (context) => OrderScreen(),
                //   setting: RouteSettings()
                  
                // )
                // );
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
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                data!.logout();
              },
              title: Text('Logout'),
              trailing: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }
}
