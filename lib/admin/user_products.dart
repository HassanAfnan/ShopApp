import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/admin/edit_product.dart';
import 'package:shopapp/provider/product_provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';

class UserProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Products"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(null)));
            },
            icon: Icon(Icons.add,color: Colors.white,),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_,i) => UserProductItem(productsData.items[i].id,productsData.items[i].title,productsData.items[i].imageUrl),
        ),
      ),
    );
  }
}
