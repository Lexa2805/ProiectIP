import 'dart:convert';
import 'package:http/http.dart' as http;

class Medicament {
  final String denumire;
  final String descriere;
  final String doza;
  final String frecventa;

  Medicament({
    required this.denumire,
    required this.descriere,
    required this.doza,
    required this.frecventa,
  });

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      denumire: json['denumire'] ?? '-',
      descriere: json['descriere'] ?? '-',
      doza: json['doza'] ?? '-',
      frecventa: json['frecventa'] ?? '-',
    );
  }
}

class GetMedicamenteEndpoint {
  static Future<List<Medicament>> getMedicamente(int idPacient) async {
    final url = Uri.parse(
      'http://10.100.1.162:8000/asistente/pacient/$idPacient/medicamente',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Medicament.fromJson(e)).toList();
    } else {
      throw Exception('Eroare la obținerea medicamentelor');
    }
  }
}
