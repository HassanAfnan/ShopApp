import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/models/orders.dart';

class OrderWidget extends StatefulWidget {
  final OrderItem order;
  OrderWidget(this.order);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  var expended = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$ ${widget.order.amount}'),
          subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            onPressed: (){
              setState(() {
                expended = !expended;
              });
            },
            icon: Icon(expended ? Icons.expand_less : Icons.expand_more),
          ),
        ),
        if(expended) Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
          height: min(widget.order.products.length * 20.0 + 10,1080),
          child: ListView(
            children: widget.order.products.map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text('${e.quantity}x \$${e.price}',style: TextStyle(fontSize: 18,color: Colors.grey),)
              ],
            )).toList(),),
        ),
      ],),
    );
  }
}
