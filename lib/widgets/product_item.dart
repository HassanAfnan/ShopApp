import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/auth.dart';
import 'package:shopapp/models/cart.dart';
import 'package:shopapp/models/products.dart';
import 'package:shopapp/screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(ProductDetail.routeName,arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                   placeholder: AssetImage('images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx,product,_) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: (){
                print("hassan");
                product.toggleFavoriteStatus(authData.token,authData.userId);
              },),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,color: Theme.of(context).accentColor,
            ),
            onPressed: (){
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(label: 'Undo',onPressed: (){
                  cart.removeSingleItem(product.id);
                },),
              ));
              },),
          title: Text(product.title,textAlign: TextAlign.center,),),
      ),
    );
  }
}
