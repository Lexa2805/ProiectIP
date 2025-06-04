import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupController extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<bool> signup(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse('http://192.168.1.137:8000/auth/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      _isLoading = false;

      if (response.statusCode == 200) {
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['detail'] ?? 'Eroare necunoscută';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Eroare de conexiune: $e';
      notifyListeners();
      return false;
    }
  }
}
