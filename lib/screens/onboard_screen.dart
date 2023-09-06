import 'package:flutter/material.dart';
import 'package:repet/data/onbaording_screens.dart';
import 'package:repet/screens/main_screen.dart';
import 'package:repet/widgets/onboard_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final onboardList = isDarkMode ? onboardListDark : onboardListLight;

    void loadPreviousOnboard() {
      setState(() {
        index--;
      });
    }

    void loadNextOnboard() {
      if (index < onboardList.length - 1) {
        setState(() {
          index++;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Image.asset(onboardList[index].image),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              onboardList[index].title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              onboardList[index].content,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: index > 0 ? loadPreviousOnboard : null,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Previous'),
                ),
                const Spacer(),
                SizedBox(
                  height: 20,
                  child: IntrinsicHeight(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: onboardList.length,
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
                  style: TextButton.styleFrom(alignment: Alignment.centerRight),
                  // It looks weird but the icon should be to the right and the
                  // text to the left, not an elegant solution but a working one
                  // for the mean time
                  label: const Icon(Icons.chevron_right),
                  icon: Text(
                    (index < onboardList.length - 1) ? 'Next' : 'Finish',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
