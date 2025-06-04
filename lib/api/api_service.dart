import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medigo/endpoints/delivery_confirm_request_endp.dart';
import 'package:medigo/endpoints/get_robot_raport_endp.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.137:8000';

  // Apelare Login
  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return response.body; // Ex: "Bine ai venit, Nume!"
    } else {
      throw Exception('Autentificare eșuată: ${response.body}');
    }
  }

  //  Obține lista de rapoarte (GET /rapoarte)
  static Future<List<RaportRobot>> getRapoarteRobot() async {
    return await GetRobotRaportEndpoint.getRapoarte();
  }

  //Status Livrare (wip)
  static Future<String> confirmDelivery(DeliveryConfirmRequest request) async {
    final url = Uri.parse('$baseUrl/delivery/confirm');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Eroare la confirmarea livrării: ${response.body}');
    }
  }

  //de adaugat altele
}
