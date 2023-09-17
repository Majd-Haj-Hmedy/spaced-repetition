import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? _selectedTheme;

  Future<void> getTheme() async {
    if (_selectedTheme != null) {
      return;
    }
    final themeMode = await AdaptiveTheme.getThemeMode();
    switch (themeMode) {
      case AdaptiveThemeMode.light:
        _selectedTheme = 0;
        break;
      case AdaptiveThemeMode.dark:
        _selectedTheme = 1;
        break;
      case AdaptiveThemeMode.system:
        _selectedTheme = 2;
        break;
      default:
        _selectedTheme = -1;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: FutureBuilder(
        future: getTheme(),
        builder: (context, snapshot) => ListView(
          children: [
            ExpansionTile(
              title: const Text('Theme'),
              trailing: const Icon(Icons.arrow_drop_down),
              children: [
                RadioListTile(
                  title: const Text('Light'),
                  value: 0,
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                    AdaptiveTheme.of(context).setLight();
                  },
                ),
                RadioListTile(
                  title: const Text('Dark'),
                  value: 1,
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                    AdaptiveTheme.of(context).setDark();
                  },
                ),
                RadioListTile(
                  title: const Text('System default'),
                  value: 2,
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                    AdaptiveTheme.of(context).setSystem();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
