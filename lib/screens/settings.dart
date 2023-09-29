import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifications/notification_service.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? _selectedTheme;
  List<String> _reminders = [];
  late final SharedPreferences _sharedPreferences;

  Future<void> _getData() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    // #region Getting the theme data
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
    // #endregion

    // #region Getting the reminders data
    _reminders = _sharedPreferences.get('reminders') as List<String>;
    // #endregion
  }

  Future<TimeOfDay?> _showTimePickerDialog() async {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  void _addReminder(TimeOfDay time) async {
    final time = await _showTimePickerDialog();
    if (time == null) {
      return;
    }
    setState(() {
      _reminders.add('${time.hour}:${time.minute}');
    });
    await _sharedPreferences.setStringList('reminders', _reminders);
    await _scheduleNotifications();
  }

  void _deleteReminder(int index) async {
    setState(() {
      _reminders.removeAt(index);
    });
    await _sharedPreferences.setStringList('reminders', _reminders);
    await _scheduleNotifications();
  }

  Future<void> _scheduleNotifications() async {
    await NotificationService().cancelAllNotifications();
    for (int i = 0; i < _reminders.length; i++) {
      await NotificationService().showScheduledNotification(
        id: i + 1,
        title: 'Study time!',
        body: 'It\'s time to study your lectures',
        dateTime: DateTime.now().copyWith(
          hour: int.parse(
            _reminders[i].substring(0, 2),
          ),
          minute: int.parse(
            _reminders[i].substring(3, 5),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appbar_settings'.i18n()),
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) => ListView(
          children: [
            ExpansionTile(
              title: Text('settings_theme'.i18n()),
              trailing: const Icon(Icons.arrow_drop_down),
              children: [
                RadioListTile(
                  title: Text('settings_theme_light'.i18n()),
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
                  title: Text('settings_theme_dark'.i18n()),
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
                  title: Text('settings_theme_system'.i18n()),
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
            ExpansionTile(
              title: Text('settings_reminders'.i18n()),
              trailing: const Icon(Icons.arrow_drop_down),
              initiallyExpanded: true,
              children: [
                for (int i = 0; i <= _reminders.length - 1; i++)
                  ListTile(
                    title: Text(
                      'settings_reminder'.i18n(
                        ['${i + 1}'],
                      ),
                    ),
                    leading: Text(
                      _reminders[i],
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14),
                    ),
                    trailing: IconButton(
                      onPressed: () => _deleteReminder(i),
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                _reminders.length == 3
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.center,
                        child: IconButton.filled(
                          onPressed: () => _addReminder(TimeOfDay.now()),
                          icon: const Icon(Icons.add),
                        ),
                      ),
                const SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
