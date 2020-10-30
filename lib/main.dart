import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/auth.dart';
import 'package:shopapp/models/cart.dart';
import 'package:shopapp/models/orders.dart';
import 'package:shopapp/provider/product_provider.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/product_detail.dart';
import 'package:shopapp/screens/product_overview.dart';
import 'package:shopapp/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(auth.token,auth.userId,previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(auth.token,auth.userId,previousOrders == null ?[]: previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth,_) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: auth.isAuth ? ProductOverview() : FutureBuilder(future: auth.tryAutoLogin(),
            builder: (ctx,authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
          ),
          routes: {
            ProductDetail.routeName: (context) => ProductDetail(),
            CartScreen.routeName: (context) => CartScreen(),
          },
        ),
      ),
    );
  }
}

