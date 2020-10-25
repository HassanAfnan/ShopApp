import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/product_provider.dart';

class ProductDetail extends StatelessWidget {

  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final modelId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(modelId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
                loadedProduct.imageUrl,
                fit:BoxFit.cover,
            ),
          ),
          SizedBox(height: 10,),
          Text(loadedProduct.title,style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
          SizedBox(height: 10,),
          Text("\$ "+loadedProduct.price.toString(),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 25),),
          SizedBox(height: 10,),
          Container(
            width: 300,
            child: FittedBox(
              child: Text(loadedProduct.description,style: TextStyle(fontSize: 12),),
            ),
          ),
        ],
      ),
    );
  }
}
