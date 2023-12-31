import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:repet/screens/about.dart';
import 'package:repet/screens/onboard_screen.dart';
import 'package:repet/screens/settings.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../constants/strings.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/repet.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  RepetStrings.appName.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: const Color(0xff5283fb),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('drawer_introduction'.i18n()),
            leading: const Icon(Icons.play_circle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingScreen(),
                ),
                (route) => false,
              );
            },
          ),
          ListTile(
            title: Text('drawer_settings'.i18n()),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('drawer_send_feedback'.i18n()),
            leading: const Icon(Icons.feedback),
            onTap: () async {
              Navigator.pop(context);
              final url = Uri.parse(
                  'mailto:majdhajhmidi@gmail.com?subject=Feedback on Repet&body=Hello,\n\nI would like to provide the following feedback:\n');
              try {
                await url_launcher.launchUrl(url);
              } catch (exception) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.warning),
                        SizedBox(width: 6),
                        Text('An error occurred'),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: Text('drawer_about'.i18n()),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
