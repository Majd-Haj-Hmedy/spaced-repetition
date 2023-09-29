import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localization/localization.dart';
import 'package:repet/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appbar_about'.i18n()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'assets/images/repet_logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        RepetStrings.appName,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        RepetStrings.appVersion,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).disabledColor,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'about_description'.i18n(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(RepetStrings.githubRepo);
                        if (await url_launcher.canLaunchUrl(url)) {
                          await url_launcher.launchUrl(url);
                        }
                      },
                      icon: const Icon(Ionicons.logo_github),
                      label: const Text('Github repository'),
                      style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
