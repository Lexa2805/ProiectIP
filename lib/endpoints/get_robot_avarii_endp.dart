/*import 'dart:convert';
import 'package:http/http.dart' as http;

class RaportAvarii {
  final String timestamp;
  final String descriere;
  final String? detalii;

  RaportAvarii({
    required this.timestamp,
    required this.descriere,
    this.detalii,
  });

  factory RaportAvarii.fromJson(Map<String, dynamic> json) {
    return RaportAvarii(
      timestamp: json['timestamp'] ?? '',
      descriere: json['descriere'] ?? '',
      detalii: json['detalii'],
    );
  }
}

class GetRobotAvariiEndpoint {
  // Schimbă cu adresa reală când backend-ul e activ
  static const String baseUrl = 'http://adresa-ta-api';

  static Future<List<RaportAvarii>> getAvarii() async {
    final url = Uri.parse('$baseUrl/avarii');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => RaportAvarii.fromJson(item)).toList();
    } else {
      throw Exception('Eroare la încărcarea avariilor: ${response.statusCode}');
    }
  }
}*/
