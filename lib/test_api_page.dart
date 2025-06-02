// test_api_page.dart

import 'package:flutter/material.dart';
import 'package:medigo/endpoints/get_robot_raport_endp.dart';

class TestApiPage extends StatefulWidget {
  const TestApiPage({Key? key}) : super(key: key);

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  List<RaportRobot> _rapoarte = [];
  int _currentIndex = 0;
  bool _loading = false;

  Future<void> _incarcaRapoarte() async {
    setState(() {
      _loading = true;
    });
    try {
      final rapoarte = await GetRobotRaportEndpoint.getRapoarte();
      setState(() {
        _rapoarte = rapoarte;
        _currentIndex = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Eroare la încărcare: $e')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _formatRaport(RaportRobot raport) {
    final data =
        DateTime.tryParse(
          raport.timestamp,
        )?.toLocal().toString().split('.')[0] ??
        'Dată invalidă';
    final actiune = raport.actiune;
    final detalii = raport.detalii ?? 'Fără detalii';
    return '[$data]\nActiune: $actiune\nDetalii: $detalii';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Test API', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _incarcaRapoarte,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Încarcă Rapoarte Robot'),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(color: Colors.white),
            if (_rapoarte.isNotEmpty && !_loading)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _formatRaport(_rapoarte[_currentIndex]),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _currentIndex > 0
                            ? () => setState(() => _currentIndex--)
                            : null,
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: _currentIndex < _rapoarte.length - 1
                            ? () => setState(() => _currentIndex++)
                            : null,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (_rapoarte.isEmpty && !_loading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Niciun raport încă.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
