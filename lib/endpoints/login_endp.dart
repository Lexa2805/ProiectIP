import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginEndpoint {
  static const String baseUrl = 'http://10.100.1.162:8000';

  static Future<String> login(String email, String password) async {
    try {
      print('Trimitere login pentru $email');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('Eroare comunicare: $e');
      throw Exception('Eroare la comunicare: $e');
    }
  }
}
