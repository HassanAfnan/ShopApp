import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/cart.dart';
import 'package:shopapp/provider/product_provider.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/product_grid.dart';

enum FilterOptions{
  Favorites,
  All
}

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showOnlyFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {
                if(selectedValue == FilterOptions.Favorites){
                  //productContainer.showFavoritesOnly();
                  _showOnlyFavorite = true;
                }
                else{
                  //productContainer.showAll();
                  _showOnlyFavorite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert), itemBuilder: (_) => [
            PopupMenuItem(child: Text('Only Favourites'),value: FilterOptions.Favorites,),
            PopupMenuItem(child: Text('Show All'),value: FilterOptions.All,),
          ],
          ),
          Consumer<Cart>(builder: (_, cartData, ch) =>
              Badge(
                  child: ch,
                  value: cartData.itemCount.toString()
               ),
                  child:IconButton(
                     icon: Icon(Icons.shopping_cart),
                     onPressed: (){
                       Navigator.of(context).pushNamed(CartScreen.routeName);
                     },
                  ),
          ),
        ],
      ),
      body: ProductGrid(_showOnlyFavorite),
    );
  }
}


