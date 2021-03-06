import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/cart.dart';
import 'package:shopapp/models/orders.dart';
import 'package:shopapp/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {

  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    var isLoading = false;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",style: TextStyle(fontSize: 20),),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text("\$ "+cart.totalAmount.toStringAsFixed(2),style: TextStyle(color: Colors.white),),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: isLoading ? CircularProgressIndicator() : Text("Order Now"),
                    onPressed: (cart.totalAmount <= 0 || isLoading) ? null : () async {
                      setState(() {
                        isLoading = true;
                      });
                      await Provider.of<Orders>(context,listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount
                      );
                      setState(() {
                        isLoading = false;
                      });
                      cart.clear();
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) => CartWidget(
                  cart.items.values.toList()[index].id,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title,
                  cart.items.keys.toList()[index],
                ),
            ),
          )
        ],
      ),
    );
  }
}
