import 'package:flutter/material.dart';
import 'package:airbnbarrendatario/Screens/LoginScreen.dart';
import 'package:airbnbarrendatario/Screens/RegisterScreen.dart';

import 'Screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirBnbArrendatario',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/agregar': (context) => Placeholder(), // Reemplaza con tu pantalla de agregar lugar
      },
    );
  }
}
