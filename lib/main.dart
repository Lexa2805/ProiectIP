import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/login_controller.dart';
import 'controllers/signup_controller.dart';
import 'package:medigo/controllers/rc_controller.dart';
import 'controllers/status_robot_controller.dart';
import 'login_page.dart';
import 'splash_screen.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => SignupController()),
        ChangeNotifierProvider(create: (_) => StatusRobotController()),
        ChangeNotifierProvider(create: (_) => RcController()),
      ],
      child: const MediGo(),
    ),
  );
}

class MediGo extends StatelessWidget {
  const MediGo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediGo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
      },
    );
  }
}
