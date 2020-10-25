import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {

  static const routeName = '/product-detail';

  // final String title;
  // final double price;
  //
  // ProductDetail(this.title,this.price);
  @override
  Widget build(BuildContext context) {
    final modelId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(modelId),
      ),
    );
  }
}
