import 'package:flutter/material.dart';

class StatusPacientiPage extends StatefulWidget {
  const StatusPacientiPage({Key? key}) : super(key: key);

  @override
  State<StatusPacientiPage> createState() => _StatusPacientiPageState();
}

class _StatusPacientiPageState extends State<StatusPacientiPage> {
  String? selectedPacient;

  final List<String> pacienti = [
    'Ion Popescu',
    'Maria Ionescu',
    'Andrei Vasilescu',
    'Elena Marinescu',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Status Pacienți',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),

            // Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[850],
                  isExpanded: true,
                  value: selectedPacient,
                  hint: const Text(
                    'Alege pacient',
                    style: TextStyle(color: Colors.white70),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blueAccent,
                  ),
                  items: pacienti.map((String pacient) {
                    return DropdownMenuItem<String>(
                      value: pacient,
                      child: Text(
                        pacient,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPacient = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Buton Status Livrare
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                // TODO: Acțiune pentru livrare
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      selectedPacient != null
                          ? 'Status livrare pentru $selectedPacient'
                          : 'Te rugăm să alegi un pacient',
                    ),
                  ),
                );
              },
              child: const Text(
                'Status Livrare',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
