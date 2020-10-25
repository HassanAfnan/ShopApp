import 'package:flutter/material.dart';
import 'package:shopapp/screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(ProductDetail.routeName,arguments: id);
            },
            child: Image.network(imageUrl,fit: BoxFit.cover,)),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(icon: Icon(Icons.favorite_border,color: Theme.of(context).accentColor,),onPressed: (){},),
          trailing: IconButton(icon: Icon(Icons.shopping_cart,color: Theme.of(context).accentColor,),onPressed: (){},),
          title: Text(title,textAlign: TextAlign.center,),),
      ),
    );
  }
}
