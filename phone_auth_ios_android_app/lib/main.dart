import 'screens/login_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const PhoneAuthApp());
}

class PhoneAuthApp extends StatelessWidget {
  const PhoneAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Auth AWS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}