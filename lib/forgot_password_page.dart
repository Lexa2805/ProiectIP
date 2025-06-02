import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperare parolă')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Poți adăuga logica de trimitere email aici
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email trimis!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Trimite email de recuperare'),
            ),
          ],
        ),
      ),
    );
  }
}
