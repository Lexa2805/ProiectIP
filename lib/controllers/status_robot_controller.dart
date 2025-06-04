import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medigo/endpoints/get_robot_raport_endp.dart';
import 'package:medigo/endpoints/get_robot_avarii_endp.dart';
//import 'package:medigo/endpoints/get_robot_avarii_endp.dart';

class StatusRobotController extends ChangeNotifier {
  //`````````````````````````RAPORT ROBOT`````````````````````````

  List<RaportRobot> _rapoarte = [];
  int _currentIndex = 0;
  bool _loading = false;
  bool modSmartphone = false; // false = Mod Automat, true = Mod Smartphone

  List<RaportRobot> get rapoarte => _rapoarte;
  int get currentIndex => _currentIndex;
  bool get loading => _loading;

  //`````````````````````````COMANDA ROBOT`````````````````````````

  Future<void> trimiteComanda(String comanda) async {
    final url = Uri.parse(
      'http://192.168.1.137:8000/robot/$comanda',
    ); // pune adresa corectă aici
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        debugPrint('Comandă trimisă cu succes: $comanda');
      } else {
        debugPrint('Eroare la trimiterea comenzii: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Excepție la trimiterea comenzii: $e');
    }
  }

  //`````````````````````````FUNCTII AJUTATOARE`````````````````````````

  Future<void> incarcaRapoarte() async {
    _loading = true;
    notifyListeners();

    try {
      final data = await GetRobotRaportEndpoint.getRapoarte();
      _rapoarte = data;
      _currentIndex = 0;
    } catch (e) {
      debugPrint("Eroare la încărcarea rapoartelor: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<RaportAvarii> _avarii = [];
  List<RaportAvarii> get avarii => _avarii;
  int get index => _currentAvarieIndex;

  int _currentAvarieIndex = 0;

  Future<void> incarcaAvarii() async {
    _loading = true;
    notifyListeners();

    try {
      final data = await GetRobotAvariiEndpoint.getAvarii();
      _avarii = data;
      _currentAvarieIndex = 0;
    } catch (e) {
      debugPrint("Eroare la încărcarea avariilor: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  String formatAvarie() {
    if (_avarii.isEmpty) return 'Nicio avarie disponibilă.';

    final raport = _avarii[_currentAvarieIndex];
    final data =
        DateTime.tryParse(
          raport.timestamp,
        )?.toLocal().toString().split('.')[0] ??
        'Dată invalidă';

    final descriere = raport.descriere;
    final tip = raport.tipAlarma;
    final status = raport.status;

    return '[$data]\nTip: $tip\nDescriere: $descriere\nStatus: $status';
  }

  void avarieUrmatoare() {
    if (_currentAvarieIndex < _avarii.length - 1) {
      _currentAvarieIndex++;
      notifyListeners();
    }
  }

  void avariePrecedenta() {
    if (_currentAvarieIndex > 0) {
      _currentAvarieIndex--;
      notifyListeners();
    }
  }

  RaportAvarii? get avarieCurenta {
    if (_avarii.isEmpty) return null;
    return _avarii[_currentAvarieIndex];
  }

  void toggleModSmartphone(bool value) {
    modSmartphone = value;
    notifyListeners();
  }

  void incrementIndex() {
    if (_currentIndex < _rapoarte.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void decrementIndex() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  String formatRaport() {
    if (_rapoarte.isEmpty) return 'Niciun raport disponibil.';

    final raport = _rapoarte[_currentIndex];
    final data =
        DateTime.tryParse(
          raport.timestamp,
        )?.toLocal().toString().split('.')[0] ??
        'Dată invalidă';
    final actiune = raport.actiune;
    final detalii = raport.detalii ?? 'Fără detalii';
    return '[$data]\nActiune: $actiune\nDetalii: $detalii';
  }
}
