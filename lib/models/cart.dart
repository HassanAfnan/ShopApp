import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    this.id,
    this.title,
    this.quantity,
    this.price
  });
}

class Cart with ChangeNotifier{
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // total no of items in cart

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
       total += value.price * value.quantity;
    });
    return total;
  }

  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }


  void addItem(String productId, double price, String title){
    if(_items.containsKey(productId)){
       _items.update(productId, (value) => CartItem(
          id: value.id,
          title: value.title,
         price: value.price,
         quantity: value.quantity + 1,
       ));
    }
    else{
      _items.putIfAbsent(productId, () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1
      ));
    }
    notifyListeners();
  }

  void clear() {
     _items = {};
     notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId].quantity > 1){
      _items.update(productId, (value) => CartItem(
        id: value.id,
        title: value.title,
        price: value.price,
        quantity: value.quantity - 1,
      ));
    }
    else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}