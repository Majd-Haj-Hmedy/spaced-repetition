import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:repet/notifications/notification_service.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/screens/main_screen.dart';
import 'package:repet/screens/onboard_screen.dart';
import 'package:repet/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  NotificationService().initNotification();
  runApp(
    ProviderScope(
      child: RepetApp(
        savedThemeMode: savedThemeMode,
      ),
    ),
  );
}

class RepetApp extends ConsumerStatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const RepetApp({
    required this.savedThemeMode,
    super.key,
  });

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
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return AdaptiveTheme(
      light: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 82, 131, 235),
        ),
        disabledColor: const Color(0xFF757575),
        useMaterial3: true,
        cardTheme: const CardTheme(
          color: Color.fromARGB(255, 246, 246, 246),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      dark: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 82, 131, 235),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.dark,
      builder: (light, dark) => ShowCaseWidget(
        disableBarrierInteraction: true,
        builder: Builder(
          builder: (context) => MaterialApp(
            theme: light,
            darkTheme: dark,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              LocalJsonLocalization.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: FutureBuilder(
              future: loadDataFromDB(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }
                if (snapshot.data == true) {
                  return const OnboardingScreen();
                }
                return const MainScreen(firstLaunch: false);
              },
            ),
          ),
        ),
      ),
    );
  }
}
