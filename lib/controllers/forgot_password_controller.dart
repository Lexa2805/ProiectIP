import 'package:flutter/material.dart';

class ForgotPasswordController extends ChangeNotifier {
  final emailController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te rugăm să introduci email-ul')),
      );
      return;
    }

    await Future.delayed(const Duration(seconds: 1)); // simulare delay

    // Aici se pune logica de resetare parola (ex. API call)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Email de resetare trimis')));
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
