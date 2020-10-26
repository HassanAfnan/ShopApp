import 'package:flutter/material.dart';
import 'package:shopapp/admin/user_products.dart';
import 'package:shopapp/screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("MyShop"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrdersScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Admin Products"),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProducts()));
            },
          )
        ],
      ),
    );
  }
}
