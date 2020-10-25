import 'package:flutter/material.dart';
import 'package:shopapp/screens/product_detail.dart';
import 'package:shopapp/screens/product_overview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
      ),
      home: ProductOverview(),
      routes: {
        ProductDetail.routeName: (context) => ProductDetail(),
      },
    );
  }
}

