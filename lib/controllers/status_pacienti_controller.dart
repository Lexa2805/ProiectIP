import 'package:flutter/material.dart';
import '../endpoints/get_saloane_endp.dart';
import '../endpoints/get_pacienti_endp.dart';
import '../endpoints/get_prescriptie.dart';

class StatusPacientiController extends ChangeNotifier {
  List<int> saloaneDisponibile = [];
  int? salonSelectat;
  List<Pacient> pacienti = [];
  bool loading = false;

  int? pacientSelectatId;

  Pacient? get pacientSelectat {
    if (pacientSelectatId == null) return null;
    try {
      return pacienti.firstWhere((p) => p.idPacient == pacientSelectatId);
    } catch (e) {
      return null; // dacă nu găsește pacientul, întoarce null
    }
  }

  Future<void> incarcaSaloane() async {
    try {
      loading = true;
      notifyListeners();

      saloaneDisponibile = await GetSaloaneEndpoint.getSaloane();

      if (saloaneDisponibile.isNotEmpty) {
        salonSelectat = saloaneDisponibile.first;
        await incarcaPacienti();
      }
    } catch (e) {
      debugPrint("Eroare saloane: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> incarcaPacienti() async {
    if (salonSelectat == null) return;

    try {
      loading = true;
      notifyListeners();

      pacienti = await GetPacientiEndpoint.getPacienti(salonSelectat!);
      pacientSelectatId =
          null; // resetăm pacientul selectat la încărcarea noii liste
    } catch (e) {
      debugPrint("Eroare pacienți: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  List<Medicament> medicamente = [];

  Future<void> incarcaMedicamente() async {
    if (pacientSelectatId == null) return;
    try {
      loading = true;
      notifyListeners();
      medicamente = await GetMedicamenteEndpoint.getMedicamente(
        pacientSelectatId!,
      );
    } catch (e) {
      debugPrint("Eroare medicamente: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> selecteazaSalon(int salon) async {
    salonSelectat = salon;
    await incarcaPacienti(); // await pentru a aștepta încărcarea pacienților
  }

  void selecteazaPacient(int id) {
    pacientSelectatId = id;
    medicamente = []; // Resetăm medicamentele înainte de încărcarea celor noi
    notifyListeners(); // Afișează imediat UI-ul fără prescripție
    incarcaMedicamente(); // Încărcăm prescripția pacientului nou
  }
}
