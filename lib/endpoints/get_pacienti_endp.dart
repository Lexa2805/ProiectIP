import 'dart:convert';
import 'package:http/http.dart' as http;

class Pacient {
  final String prenume;
  final String nume;
  final String adresa;
  final int salon;
  final String cnp;
  final int idPacient;
  final String telefon;
  final int pat;

  Pacient({
    required this.prenume,
    required this.nume,
    required this.adresa,
    required this.salon,
    required this.cnp,
    required this.idPacient,
    required this.telefon,
    required this.pat,
  });

  factory Pacient.fromJson(Map<String, dynamic> json) {
    return Pacient(
      prenume: json['prenume'],
      nume: json['nume'],
      adresa: json['adresa'],
      salon: json['salon'],
      cnp: json['CNP'],
      idPacient: json['ID_pacient'],
      telefon: json['telefon'],
      pat: json['pat'],
    );
  }
}

class GetPacientiEndpoint {
  static Future<List<Pacient>> getPacienti(int idSalon) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/asistente/salon/$idSalon/pacienti'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((e) => Pacient.fromJson(e)).toList();
    } else {
      throw Exception('Eroare la obținerea pacienților');
    }
  }
}
