import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/screens/main_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: RepetApp(),
    ),
  );
}

class RepetApp extends StatelessWidget {
  const RepetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 82, 131, 235),
          brightness: Brightness.dark
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
