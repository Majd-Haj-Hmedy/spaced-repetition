import 'package:flutter/material.dart';
import 'package:repet/screens/main_screen.dart';

void main() {
  runApp(const RepetApp());
}

class RepetApp extends StatelessWidget {
  const RepetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 82, 131, 235),
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
