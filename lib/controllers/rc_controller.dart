import 'package:flutter/material.dart';
import '../endpoints/post_rc_endp.dart';

class RcController extends ChangeNotifier {
  bool _isOn = false;
  bool get isOn => _isOn;

  void toggleRcSwitch(bool value) async {
    _isOn = value;
    notifyListeners(); // actualizează UI-ul

    final command = _isOn ? 'rc-on' : 'rc-off';
    await RcService.sendRcCommand(command);
  }
}
