import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Eğer login_screen.dart başka klasördeyse yolu güncelle

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: const LoginScreen(),
    );
  }
}
