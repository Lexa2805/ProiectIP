import 'dart:convert';
import 'package:http/http.dart' as http;

class RaportRobot {
  final int id;
  final String actiune;
  final String? detalii;
  final String timestamp;

  RaportRobot({
    required this.id,
    required this.actiune,
    this.detalii,
    required this.timestamp,
  });

  factory RaportRobot.fromJson(Map<String, dynamic> json) {
    return RaportRobot(
      id: json['id'],
      actiune: json['actiune'],
      detalii: json['detalii'],
      timestamp: json['timestamp'],
    );
  }
}

class GetRobotRaportEndpoint {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<RaportRobot>> getRapoarte() async {
    final url = Uri.parse('$baseUrl/rapoarte');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => RaportRobot.fromJson(item)).toList();
    } else {
      throw Exception('Eroare la obținerea rapoartelor: ${response.body}');
    }
  }
}
