import 'package:flutter/material.dart';
import 'api/api_service.dart';

class TestApiPage extends StatefulWidget {
  const TestApiPage({Key? key}) : super(key: key);

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  final _emailController = TextEditingController(text: 'test@spital.ro');
  final _passwordController = TextEditingController(text: '123456');

  String _responseText = '';
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _responseText = '';
    });

    try {
      String message = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _responseText = message;
      });
    } catch (e) {
      setState(() {
        _responseText = 'Eroare: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blueAccent = Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Autentificare API'),
        backgroundColor: blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Parolă',
                prefixIcon: Icon(Icons.lock, color: blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: blueAccent,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Conectează-te'),
            ),
            const SizedBox(height: 30),
            Text(_responseText, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
