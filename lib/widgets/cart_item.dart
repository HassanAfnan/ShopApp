import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/cart.dart';

class CartWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartWidget(this.id,this.price,this.quantity,this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      confirmDismiss: (direction){
        return showDialog(context: context,
          builder: (ctx) =>AlertDialog(
            title: Text("Are you sure?"),
            content: Text("You want to remove item from cart"),
            actions: [
              FlatButton(
                child: Text("No"),
                onPressed: (){
                   Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
              ),
            ],
        ),
        );
      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4
        ),
        alignment: Alignment.centerRight,
        color: Colors.redAccent,
        child: Icon(Icons.delete,color: Colors.white,size: 40,),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('\$ ${price}',style: TextStyle(fontWeight: FontWeight.bold),),
              )),
            ),
            title: Text(title),
            subtitle: Text('Total: \$ ${(price * quantity)}'),
            trailing: Text('${quantity} x'),
          ),
        ),
      ),
    );
  }
}
