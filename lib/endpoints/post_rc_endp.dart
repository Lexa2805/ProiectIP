import 'dart:convert';
import 'package:http/http.dart' as http;

class RcService {
  static const String baseUrl = 'http://192.168.1.137:8000';

  static Future<void> sendRcCommand(String command) async {
    final url = Uri.parse('$baseUrl/rc');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': command,
        }), // cheia este 'status', nu 'command'
      );

      if (response.statusCode != 200) {
        print('Eroare la trimitere: ${response.statusCode}');
      } else {
        print('Comandă trimisă cu succes: $command');
      }
    } catch (e) {
      print('Eroare rețea: $e');
    }
  }
}
