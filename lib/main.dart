import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/screens/main_screen.dart';
import 'package:repet/screens/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: RepetApp(),
    ),
  );
}

class RepetApp extends ConsumerStatefulWidget {
  const RepetApp({super.key});

  @override
  ConsumerState<RepetApp> createState() => _RepetAppState();
}

class _RepetAppState extends ConsumerState<RepetApp> {
  Future<void> loadDataFromDB() async {
    await ref.read(foldersProvider.notifier).loadFolders();
    await ref.read(lecturesProvider.notifier).loadLectures();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 82, 131, 235),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: loadDataFromDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return const MainScreen();
        },
      ),
    );
  }
}
