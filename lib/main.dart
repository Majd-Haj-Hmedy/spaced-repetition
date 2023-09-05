import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/screens/main_screen.dart';
import 'package:repet/screens/onboarding/main_onboard.dart';
import 'package:repet/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<bool> loadDataFromDB() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getBool('first_launch');
    if (firstLaunch == null) {
      await prefs.setBool('first_launch', true);
    }
    await ref.read(foldersProvider.notifier).loadFolders();
    await ref.read(lecturesProvider.notifier).loadLectures();
    return firstLaunch == null;
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
          if (snapshot.data == true) {
            return const MainOnboardingScreen();
          }
          return const MainScreen();
        },
      ),
    );
  }
}
