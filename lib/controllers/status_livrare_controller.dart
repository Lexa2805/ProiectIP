import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardController extends ChangeNotifier {
  String _name = '';
  String get name => _name;

  // Pentru status livrare:
  String? _statusLivrareText;
  String? get statusLivrareText => _statusLivrareText;

  bool _loadingStatusLivrare = false;
  bool get loadingStatusLivrare => _loadingStatusLivrare;

  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }

  Future<void> fetchStatusLivrare() async {
    _loadingStatusLivrare = true;
    _statusLivrareText = null;
    notifyListeners();

    try {
      final url = Uri.parse(
        'http://adresa_ta_backend/asistente/api/confirmari_rfid/ultimul',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Construiește textul după structura răspunsului
        final rfid = data['rfid'] ?? 'N/A';
        final timestamp = data['timestamp'] ?? 'N/A';

        _statusLivrareText = 'RFID: $rfid\nTimestamp: $timestamp';
      } else {
        _statusLivrareText = 'Eroare la preluarea statusului';
      }
    } catch (e) {
      _statusLivrareText = 'Eroare: $e';
    } finally {
      _loadingStatusLivrare = false;
      notifyListeners();
    }
  }
}
