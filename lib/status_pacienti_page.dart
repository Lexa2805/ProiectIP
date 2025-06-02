import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medigo/controllers/status_pacienti_controller.dart';
import 'package:medigo/endpoints/get_pacienti_endp.dart';

class StatusPacientiPage extends StatelessWidget {
  const StatusPacientiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatusPacientiController()..incarcaSaloane(),
      child: Consumer<StatusPacientiController>(
        builder: (context, controller, _) {
          final blueAccent = Colors.blueAccent;
          final lightGrey = const Color(0xFFF0F0F0);

          return Scaffold(
            backgroundColor: lightGrey,
            appBar: AppBar(
              backgroundColor: blueAccent,
              title: const Text(
                "Status Pacienți",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selectează Salon:',
                      style: TextStyle(
                        color: blueAccent.shade700,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Dropdown Salon
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: blueAccent, width: 2),
                      ),
                      child: DropdownButton<int>(
                        value: controller.salonSelectat,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items: controller.saloaneDisponibile.map((salon) {
                          return DropdownMenuItem(
                            value: salon,
                            child: Text(
                              salon.toString(),
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (val) {
                          if (val != null) {
                            controller.selecteazaSalon(val);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      'Selectează Pacient:',
                      style: TextStyle(
                        color: blueAccent.shade700,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Dropdown Pacient
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: blueAccent, width: 2),
                      ),
                      child: DropdownButton<int>(
                        value: controller.pacientSelectatId,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items: controller.pacienti.map<DropdownMenuItem<int>>(
                          (Pacient pacient) {
                            return DropdownMenuItem<int>(
                              value: pacient.idPacient,
                              child: Text(
                                '${pacient.prenume} ${pacient.nume}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            );
                          },
                        ).toList(),
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (val) {
                          if (val != null) controller.selecteazaPacient(val);
                        },
                      ),
                    ),

                    if (controller.pacientSelectat != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detalii pacient:',
                              style: TextStyle(
                                color: Colors.blueAccent.shade700,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            InfoRow(
                              label: 'Nume',
                              value:
                                  '${controller.pacientSelectat!.prenume} ${controller.pacientSelectat!.nume}',
                            ),
                            InfoRow(
                              label: 'Adresa',
                              value: controller.pacientSelectat!.adresa,
                            ),
                            InfoRow(
                              label: 'Telefon',
                              value: controller.pacientSelectat!.telefon,
                            ),
                            InfoRow(
                              label: 'Pat',
                              value: controller.pacientSelectat!.pat.toString(),
                            ),

                            const SizedBox(height: 20),

                            // Afișăm prescripția doar dacă există medicamente
                            if (controller.medicamente.isNotEmpty) ...[
                              Text(
                                'Prescripție:',
                                style: TextStyle(
                                  color: Colors.blueAccent.shade700,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...controller.medicamente.map((med) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '• ${med.denumire}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        '  Descriere: ${med.descriere}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        '  Doza: ${med.doza}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        '  Frecvență: ${med.frecventa}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ] else ...[
                              const Text(
                                'Nu există prescripție pentru acest pacient.',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 25),

                    if (controller.loading)
                      Center(
                        child: CircularProgressIndicator(color: blueAccent),
                      ),

                    if (!controller.loading && controller.pacienti.isEmpty)
                      Text(
                        "Niciun pacient în acest salon.",
                        style: TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
