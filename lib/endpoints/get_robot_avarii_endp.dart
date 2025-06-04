import 'dart:convert';
import 'package:http/http.dart' as http;

class RaportAvarii {
  final String timestamp;
  final String descriere;
  final String tipAlarma;
  final String status;

  RaportAvarii({
    required this.timestamp,
    required this.descriere,
    required this.tipAlarma,
    required this.status,
  });

  factory RaportAvarii.fromJson(Map<String, dynamic> json) {
    return RaportAvarii(
      timestamp: json['data_ora'] ?? '',
      descriere: json['descriere'] ?? '',
      tipAlarma: json['tip_alarma'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class GetRobotAvariiEndpoint {
  // Schimbă cu adresa reală când backend-ul e activ
  static const String baseUrl = 'http://192.168.1.137:8000';

  static Future<List<RaportAvarii>> getAvarii() async {
    final url = Uri.parse('$baseUrl/api/alarme');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => RaportAvarii.fromJson(item)).toList();
    } else {
      throw Exception('Eroare la încărcarea avariilor: ${response.statusCode}');
    }
  }
}
