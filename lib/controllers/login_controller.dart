import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse('http://10.0.2.2:8000/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      _isLoading = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? '';
        final name = message
            .replaceAll('Bine ai venit, ', '')
            .replaceAll('!', '');

        _errorMessage = null;
        notifyListeners();

        return {'success': true, 'name': name};
      } else {
        try {
          final data = jsonDecode(response.body);
          _errorMessage = data['detail'] ?? 'Eroare necunoscută';
        } catch (e) {
          _errorMessage = 'Eroare necunoscută';
        }
        notifyListeners();
        return {'success': false};
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Eroare de conexiune: $e';
      notifyListeners();
      return {'success': false};
    }
  }
}
