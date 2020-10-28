import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
   final String id;
   final String title;
   final String description;
   final double price;
   final String imageUrl;
   bool isFavorite;

   Product({
     this.id,
     this.title,
     this.description,
     this.imageUrl,
     this.price,
     this.isFavorite = false
   });

   Future<void> toggleFavoriteStatus() async{
     final oldStatus = isFavorite;
     isFavorite = !isFavorite;
     notifyListeners();
     final url = 'https://shopapp-6fa47.firebaseio.com/products/$id.json';
     try{
      final response = await http.patch(url,body: json.encode({
         'isFavorite': isFavorite,
       }));
      if(response.statusCode >= 400){
        isFavorite = oldStatus;
        notifyListeners();
      }
     }catch(error){
       isFavorite = oldStatus;
       notifyListeners();
     }
   }
}