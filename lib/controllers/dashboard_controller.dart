import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  String _name = '';

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String get name => _name;
}
