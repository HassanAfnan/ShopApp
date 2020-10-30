import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/admin/user_products.dart';
import 'package:shopapp/models/auth.dart';
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
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("logout"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProducts()));
              Provider.of<Auth>(context,listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
