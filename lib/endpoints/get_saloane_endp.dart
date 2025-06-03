import 'dart:convert';
import 'package:http/http.dart' as http;

class GetSaloaneEndpoint {
  static Future<List<int>> getSaloane() async {
    final response = await http.get(
      Uri.parse('http://10.100.1.162:8000/asistente/saloane'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<int>();
    } else {
      throw Exception('Eroare la încărcarea saloanelor');
    }
  }
}
