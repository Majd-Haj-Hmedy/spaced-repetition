import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:repet/constants/colors.dart';
import '../widgets/reports/active_folder.dart';

// ignore: must_be_immutable
class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with real data

    Future<List<int>> loadLectureCountData() async {
      return [10, 3, 1];
    }

    Future<int> loadProductivityData() async {
      return -45;
    }

    Future<int> loadStreakData() async {
      return 5;
    }

    Future<List<String>> loadActiveFoldersData() async {
      return [
        'Anatomy',
        'Biology',
        'Physics',
      ];
    }

    Future<Map<DateTime, int>> loadCompletionHeatmapData() async {
      return {
        DateTime(2023, 9, 6): 1,
        DateTime(2023, 9, 7): 3,
        DateTime(2023, 9, 8): 5,
        DateTime(2023, 9, 9): 6,
        DateTime(2023, 9, 13): 8,
      };
    }

    return Center(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          FutureBuilder(
            future: loadLectureCountData(),
            builder: (context, snapshot) => Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Lecture stats',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Completed',
                              style: TextStyle(
                                color: RepetColors.statusCheck,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            !snapshot.hasData
                                ? const CircularProgressIndicator.adaptive()
                                : Text(
                                    '${snapshot.data![0]}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Noto Mono',
                                    ),
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Delayed',
                              style: TextStyle(
                                color: RepetColors.statusDelayed,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            !snapshot.hasData
                                ? const CircularProgressIndicator.adaptive()
                                : Text(
                                    '${snapshot.data![1]}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Noto Mono',
                                    ),
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Skipped',
                              style: TextStyle(
                                color: RepetColors.statusSkipped,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            !snapshot.hasData
                                ? const CircularProgressIndicator.adaptive()
                                : Text(
                                    '${snapshot.data![2]}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Noto Mono',
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: loadProductivityData(),
            builder: (context, snapshot) => Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Column(
                        children: [
                          Text(
                            'Productivity',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                snapshot.data! < 0
                                    ? Ionicons.arrow_down_circle
                                    : Ionicons.arrow_up_circle,
                                color: snapshot.data! > 0
                                    ? RepetColors.statusCheck
                                    : RepetColors.statusSkipped,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${snapshot.data!.abs()}% Compared to previous week',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: loadStreakData(),
            builder: (context, snapshot) => Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Streak',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: !snapshot.hasData
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : snapshot.data == 0
                                  ? const Text(
                                      'You lost your streak..\nDon\'t give up!',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        text: 'You\'re on a ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        children: [
                                          TextSpan(
                                            text:
                                                '${snapshot.data!} ${snapshot.data! == 1 ? 'day' : 'days'} streak!',
                                            style: const TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: '\nKeep it up!',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                        ),
                        Image.asset(
                          'assets/images/streak.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: loadActiveFoldersData(),
            builder: (context, snapshot) => Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Active Folders',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),

                    /*
                     This nested conditioning checks if the data is loaded or 
                     not, in which case, the list is checked whether it's empty
                     or not
                    */

                    !snapshot.hasData
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : snapshot.data!.isEmpty
                            ? const Center(
                                child: Text('No folders created!'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return ActiveFolder(
                                    rank: index + 1,
                                    name: snapshot.data![index],
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: loadCompletionHeatmapData(),
            builder: (context, snapshot) => Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Completion heatmap',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    !snapshot.hasData
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : HeatMapCalendar(
                            defaultColor: Theme.of(context).cardColor,
                            colorMode: ColorMode.color,
                            textColor: Theme.of(context).hintColor,
                            datasets: snapshot.data!,
                            colorsets: {
                              1: Colors.green[300]!,
                              2: Colors.green[400]!,
                              3: Colors.green[500]!,
                              4: Colors.green[600]!,
                              5: Colors.green[700]!,
                            },
                            onClick: (value) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(snapshot.data![value] == null
                                      ? 'No lectures completed'
                                      : '${snapshot.data![value].toString()} Lectures completed'),
                                ),
                              );
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
