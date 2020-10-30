import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/models/products.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier{
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;
  Products(this.authToken,this.userId,this._items);


  //var _showFavoritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }


  Product findById(String id){
    return _items.firstWhere((element) => element.id == id);
  }

  // we can add auth with products
  // add userid to add product
  // after token $ orderBy="userID"&equalTo="userId"
  // change rules in firebase
  // after read and write
  // "products": {".indexOn": ["userId"] }
  // also see WebHD_720p in downloads folder on windows
  Future<void> addProduct(Product product) async {
    final url = 'https://shopapp-6fa47.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
      );
      print(json.decode(response.body));
      final newProduct = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name']
      );
      _items.add(newProduct);
      notifyListeners();
    }catch(error){
      print(error);
      throw error;
    }

    // use this code without async and await
    // const url = 'https://shopapp-6fa47.firebaseio.com/products.json';
    // return http.post(url,body: json.encode({
    //   'title': product.title,
    //   'description': product.description,
    //   'price': product.price,
    //   'imageUrl': product.imageUrl,
    //   'isFavorite': product.isFavorite
    // })).then((response){
    //   print(json.decode(response.body));
    //   final newProduct = Product(
    //       title: product.title,
    //       price: product.price,
    //       description: product.description,
    //       imageUrl: product.imageUrl,
    //       id: json.decode(response.body)['name']
    //   );
    //   _items.add(newProduct);
    //   notifyListeners();
    // }).catchError((error){
    //     print(error);
    //     throw error;
    //});
  }

  // fetch data from http
  Future<void> fetchAndSetProducts() async {
    var url = 'https://shopapp-6fa47.firebaseio.com/products.json?auth=$authToken';
    try{
      final response = await http.get(url);
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if(extractedData == null){
        return;
      }
       url = 'https://shopapp-6fa47.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl']
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

  void updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if(prodIndex >= 0){
      final url = 'https://shopapp-6fa47.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url, body: json.encode({
         'title': newProduct.title,
         'description': newProduct.description,
         'imageUrl': newProduct.imageUrl,
         'price': newProduct.price,
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }else{
      print("hassan");
    }
  }

  Future<void> deleteProduct(String id) async{
    final url = 'https://shopapp-6fa47.firebaseio.com/products/$id.json?auth=$authToken';
    final exsistingIndex = _items.indexWhere((element) => element.id == id);
    var exsistingProduct = _items[exsistingIndex];
    _items.removeAt(exsistingIndex);
    notifyListeners();
    final value = await http.delete(url);
      if(value.statusCode >= 400){
        _items.insert(exsistingIndex, exsistingProduct);
        notifyListeners();
        throw HttpException('Could not delete product');
      }
      exsistingProduct = null;
  }
}