import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/https_exception.dart';
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expirydate;
  Timer? _authtimer;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId ?? '';
  }

  String? get token {
    if (_expirydate != null &&
        _expirydate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return '';
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    try {
      var url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAgFsERhEq4uQ7Zvux4y23dygRd8XYRUFA';
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _userId = data['localId'];
      _expirydate = DateTime.now().add(Duration(
        seconds: int.parse(
          data['expiresIn'],
        ),
      ));
      _autologout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiry': _expirydate!.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> SignUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> LogIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expirydate = null;
    if (_authtimer != null) {
      _authtimer!.cancel();
      _authtimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final  extractedData =
        json.decode(prefs.getString('userData')!);

    final expiryDate = DateTime.parse(extractedData!['expiry'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    _expirydate = expiryDate;
    notifyListeners();
    _autologout();
    return true;
  }

  void _autologout() {
    if (_authtimer != null) {
      _authtimer!.cancel();
    }
    final expiryTime = _expirydate!.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: expiryTime), logout);
    notifyListeners();
  }
}
