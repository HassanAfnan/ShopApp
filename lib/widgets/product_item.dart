import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/cart.dart';
import 'package:shopapp/models/products.dart';
import 'package:shopapp/screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(ProductDetail.routeName,arguments: product.id);
            },
            child: Image.network(product.imageUrl,fit: BoxFit.cover,)),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx,product,_) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: (){
                product.toggleFavoriteStatus();
              },),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,color: Theme.of(context).accentColor,
            ),
            onPressed: (){
              cart.addItem(product.id, product.price, product.title);
            },),
          title: Text(product.title,textAlign: TextAlign.center,),),
      ),
    );
  }
}
