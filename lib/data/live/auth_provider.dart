import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _username;
  String? _email;
  String? _role;

  String? get token => _token;
  String? get username => _username;
  String? get email => _email;
  String? get role => _role;

  void login(String token, String username, String email, String role) {
    _token = token;
    _username = username;
    _email = email;
    _role = role;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _username = null;
    _email = null;
    _role = null;
    notifyListeners();
  }
}