import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localization/localization.dart';
import 'package:repet/constants/colors.dart';
import 'package:repet/util/date_format.dart';
import '../data/database_helper.dart';
import '../widgets/reports/active_folder.dart';

class ReportScreen extends ConsumerWidget {
  ReportScreen({super.key});

  final List<int> lectureStats = [];
  final Map<DateTime, int> heatmap = {};

  // TODO: Replace with real data
  Future<void> loadData() async {
    final db = await DatabaseHelper.getDatabase();
    final loadedCompletions = await db.query('completions');

    var currentWeekCompletions = 0;
    var previousWeekCompletions = 0;

    for (final row in loadedCompletions) {
      final lectureStatus = row['status'] as int;
      final lectureDate =
          MultipleDateFormat.simpleYearParseString(row['status'] as String);
      final folderName = row['status'] as String;
      switch (lectureStatus) {
        case 1:
          lectureStats[0] += 1;
          heatmap[lectureDate] = heatmap[lectureDate] ?? 0 + 1;
          break;
        case 0:
          lectureStats[1] += 1;
          break;
        case -1:
          lectureStats[2] += 1;
          break;
      }
      // TODO: Handle week productivity
      // TODO: Handle folders ranking
    }
  }

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      'reports_lecture_stats_title'.i18n(),
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
                              'reports_lecture_stats_completed'.i18n(),
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
                              'reports_lecture_stats_delayed'.i18n(),
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
                              'reports_lecture_stats_skipped'.i18n(),
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
                            'reports_productivity_title'.i18n(),
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
                                '${snapshot.data!.abs()}% ${'reports_productivity_content'.i18n()}',
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
                      'reports_streak_title'.i18n(),
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
                                  ? Text(
                                      'reports_streak_lost_streak'.i18n(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        text: 'reports_streak_content_first'
                                            .i18n(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        children: [
                                          TextSpan(
                                            text: 'reports_streak_content_data'
                                                .i18n(
                                              [
                                                '${snapshot.data!}',
                                                snapshot.data! == 1
                                                    ? 'day'
                                                    : 'days'
                                              ],
                                            ),
                                            style: const TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'reports_streak_content_last'
                                                .i18n(),
                                            style:
                                                const TextStyle(fontSize: 16),
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
                      'reports_active_folders_title'.i18n(),
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
                            ? Center(
                                child: Text(
                                    'reports_active_folders_no_folders'.i18n()),
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
                      'reports_heatmap_title'.i18n(),
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
                            colorTipHelper: [
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child:
                                    Text('reports_heatmap_legend_less'.i18n()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child:
                                    Text('reports_heatmap_legend_more'.i18n()),
                              ),
                            ],
                            onClick: (value) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    snapshot.data![value] == null
                                        ? 'reports_heatmap_no_lectures'.i18n()
                                        : 'reports_heatmap_lectures_completed_snackbar_message'
                                            .i18n(
                                            [
                                              snapshot.data![value].toString(),
                                            ],
                                          ),
                                  ),
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
