import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/https_exception.dart';
import "package:http/http.dart" as http;

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expirydate;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId!;
  }

  String? get token {
    if (_expirydate != null &&
        _expirydate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
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
      notifyListeners();
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
}
