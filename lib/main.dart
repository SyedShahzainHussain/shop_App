import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "package:flutter_application_1/Models/Product.dart";
import "package:flutter_application_1/Provider/Auth.dart";
import "package:flutter_application_1/Provider/Order.dart";
import "package:flutter_application_1/Provider/Products.dart";
import "package:flutter_application_1/screen/AuthScreen.dart";
import "package:flutter_application_1/screen/CartScreen.dart";
import "package:flutter_application_1/screen/DetailScreen.dart";
import "package:flutter_application_1/screen/EditProductScreen.dart";
import "package:flutter_application_1/screen/OrderScreen.dart";
import "package:flutter_application_1/screen/UserProductScreen.dart";
import "package:provider/provider.dart";
import "./screen/OverviewScreen.dart";
import "Provider/Cart.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products("", [],""),
      
          update: (context, value, previous) =>
              Products(value.token!, previous == null ? [] : previous.items,value.userId),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderItem>(
             create: (ctx) => OrderItem("", []),
      
          update: (context, value, previous) =>
              OrderItem(value.token!, previous == null ? [] : previous.order),
        ),
      
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth ? OverviewScreen() : AuthScreen(),
            routes: {
              DetailScreen.routeName: (context) => DetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
