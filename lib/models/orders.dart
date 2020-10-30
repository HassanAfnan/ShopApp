import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/models/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime
  });
}

class Orders with ChangeNotifier{
   List<OrderItem> _orders = [];
   final String authToken;
   final String userId;

   Orders(this.authToken,this.userId,this._orders);

   List<OrderItem> get orders{
     return [..._orders];
   }

   void addOrder(List<CartItem> cartProducts, double total) async{
     final url = 'https://shopapp-6fa47.firebaseio.com/orders/$userId.json?auth=$authToken';
     final timespan = DateTime.now();
     final response = await http.post(url,body: json.encode({
       'amount': total,
       'dateTime': timespan.toIso8601String(),
       'products': cartProducts.map((e) => {
         'id': e.id,
         'title': e.title,
         'quantity': e.quantity,
         'price': e.price
       }).toList(),
     }));
     _orders.insert(0, OrderItem(
       id: json.decode(response.body)['name'],
       amount: total,
       products: cartProducts,
       dateTime: timespan
     ));
     notifyListeners();
   }

   Future<void> fetchAndSetOrders() async{
     final url = 'https://shopapp-6fa47.firebaseio.com/orders/$userId.json?auth=$authToken';
     final response = await http.get(url);
     print(json.decode(response.body));
     final List<OrderItem> loadedOrders = [];
     final extracteddate = json.decode(response.body) as Map<String,dynamic>;
     if(extracteddate == null){
       return;
     }
     extracteddate.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((e) =>CartItem(
              id: e['id'],
              price: e['price'],
              quantity: e['quantity'],
              title: e['title']
            ),
          ).toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
   }
}