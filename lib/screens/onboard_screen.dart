import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:repet/data/onboard_data.dart';
import 'package:repet/screens/main_screen.dart';
import 'package:repet/widgets/onboarding/onboard_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var index = 0;
  final _onboardPagesController = PageController();

  @override
  void dispose() {
    _onboardPagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < onboardData.length; i++) {
      precacheImage(AssetImage(onboardData[i].image), context);
    }

    void loadPreviousOnboard() {
      _onboardPagesController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        index--;
      });
    }

    void loadNextOnboard() {
      if (index < onboardData.length - 1) {
        _onboardPagesController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          index++;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(firstLaunch: true),
          ),
        );
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: onboardData.length,
                onPageChanged: (int newIndex) {
                  setState(() {
                    index = newIndex;
                  });
                },
                controller: _onboardPagesController,
                itemBuilder: (BuildContext context, int pageIndex) {
                  return Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Image.asset(onboardData[pageIndex].image),
                        const SizedBox(height: 50),
                        Text(
                          onboardData[pageIndex].title,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          onboardData[pageIndex].content,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: index > 0 ? loadPreviousOnboard : null,
                    icon: const Icon(Icons.chevron_left),
                    label: Text('onboard_actions_prev'.i18n()),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 20,
                    child: IntrinsicHeight(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: onboardData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: OnboardItem(isSelected: this.index == index),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: loadNextOnboard,
                    style:
                        TextButton.styleFrom(alignment: Alignment.centerRight),
                    // It looks weird but the icon should be to the right and the
                    // text to the left, not an elegant solution but a working one
                    // for the mean time
                    label: const Icon(Icons.chevron_right),
                    icon: Text(
                      (index < onboardData.length - 1)
                          ? 'onboard_actions_next'.i18n()
                          : 'onboard_actions_finish'.i18n(),
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
