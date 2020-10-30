import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/models/http_exception.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer authTimer;

  bool get isAuth{
    return token != null;
  }

  String get token {
    if(_expireDate != null && _expireDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  String get userId{
    return _userId;
  }

  void logout() async{
    _token = null;
    _userId = null;
    _expireDate = null;
    if(authTimer != null){
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  // we can call it if required but i am not using it
  void autoLogout() {
    if(authTimer != null){
      authTimer.cancel();
    }
    final timetoExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timetoExpiry),logout);
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDate = extractedUserData['expiryDate'];
     notifyListeners();
     return true;
  }

  Future<void> signup(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAeBeV6Y9xGHhnp4jmP7yv_OrNZZSBGO4E';
    try {
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }
      ),);
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expireDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireDate.toIso8601String()
      });
      prefs.setString('userData',userData);
    }catch(error){
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAeBeV6Y9xGHhnp4jmP7yv_OrNZZSBGO4E';
    try {
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }
      ),);
      print(json.decode(response.body));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expireDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireDate.toIso8601String()
      });
      prefs.setString('userData',userData);
    }catch(error){
      throw error;
    }
  }
}
