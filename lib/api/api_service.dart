import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.100.148:8000';

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password, // cheia corectă cerută de backend
      }),
    );

    if (response.statusCode == 200) {
      return response.body; // Ex: "Bine ai venit, Nume!"
    } else {
      throw Exception('Autentificare eșuată: ${response.body}');
    }
  }

  // alte metode vor fi aici, dacă le ai deja
}
