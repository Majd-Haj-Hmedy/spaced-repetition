import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localization/localization.dart';
import 'package:repet/constants/colors.dart';
import 'package:repet/screens/home.dart';
import 'package:repet/util/date_format.dart';
import '../data/database_helper.dart';
import '../widgets/reports/active_folder.dart';

// ignore: must_be_immutable
class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final List<int> lectureStatistics = [0, 0, 0];
  var productivity = 0;
  var streak = 0;
  final Map<DateTime, int> heatmap = {};
  final List<String> activeFolders = [];

  Future<void> loadData() async {
    final db = await DatabaseHelper.getDatabase();
    final loadedCompletions = await db.query('completions');

    final Map<String, int> foldersMap = {};
    var currentWeekProductivity = 0;
    var previousWeekProductivity = 0;

    for (final row in loadedCompletions) {
      final completionStatus = row['status'] as int;
      final completionDate =
          MultipleDateFormat.simpleYearParseString(row['date'] as String);
      final folderName = row['folder_name'] as String;
      switch (completionStatus) {
        case 1:
          lectureStatistics[0]++;
          foldersMap[folderName] = (foldersMap[folderName] ?? 0) + 1;
          heatmap[completionDate] = (heatmap[completionDate] ?? 0) + 1;
          if (completionDate.compareTo(
                  completionDate.subtract(const Duration(days: 7))) >=
              0) {
            currentWeekProductivity += 1;
          } else if (completionDate.compareTo(
                  completionDate.subtract(const Duration(days: 14))) >=
              0) {
            previousWeekProductivity += 1;
          }
          break;
        case 0:
          foldersMap[folderName] = foldersMap[folderName] ?? 0;
          lectureStatistics[1]++;
          heatmap[completionDate] = (heatmap[completionDate] ?? 0) + 1;
          break;
        case -1:
          foldersMap[folderName] = (foldersMap[folderName] ?? 0) - 1;
          lectureStatistics[2]++;
          if (completionDate.compareTo(
                  completionDate.subtract(const Duration(days: 7))) >=
              0) {
            currentWeekProductivity -= 1;
          } else if (completionDate.compareTo(
                  completionDate.subtract(const Duration(days: 14))) >=
              0) {
            previousWeekProductivity -= 1;
          }
          break;
      }
    }
    if (previousWeekProductivity == 0) {
      productivity = 100;
    } else {
      productivity = (currentWeekProductivity - previousWeekProductivity) ~/
          previousWeekProductivity *
          100;
    }

    // #region Sorting 3 most active folders
    for (int i = 0; i <= 2; i++) {
      MapEntry<String, int>? maxEntry;
      for (final folder in foldersMap.entries) {
        if (maxEntry == null || folder.value > maxEntry.value) {
          maxEntry = folder;
        }
      }
      if (maxEntry != null) {
        activeFolders.add(maxEntry.key);
        foldersMap.remove(maxEntry.key);
      }
    }
    // #endregion

    var currentDate = DateTime.now().removeTime();
    while (true) {
      if (heatmap[currentDate] == 0 || heatmap[currentDate] == null) {
        return;
      }
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) => ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Card(
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
                            snapshot.connectionState == ConnectionState.waiting
                                ? const CircularProgressIndicator.adaptive()
                                : Text(
                                    '${lectureStatistics[0]}',
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
                            snapshot.connectionState == ConnectionState.waiting
                                ? const CircularProgressIndicator.adaptive()
                                : Text(
                                    '${lectureStatistics[1]}',
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
                            snapshot.connectionState == ConnectionState.waiting
                                ? const CircularProgressIndicator.adaptive()
                                : Text(
                                    '${lectureStatistics[2]}',
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
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: snapshot.connectionState == ConnectionState.waiting
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
                                productivity < 0
                                    ? Ionicons.arrow_down_circle
                                    : Ionicons.arrow_up_circle,
                                color: productivity < 0
                                    ? RepetColors.statusSkipped
                                    : RepetColors.statusCheck,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${productivity.abs()}% ${'reports_productivity_content'.i18n()}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
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
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : streak == 0
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
                                                '$streak',
                                                streak == 1 ? 'day' : 'days'
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
            const SizedBox(height: 10),
            Card(
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
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : HeatMapCalendar(
                            defaultColor: Theme.of(context).cardColor,
                            colorMode: ColorMode.color,
                            textColor: Theme.of(context).hintColor,
                            datasets: heatmap,
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
                                    heatmap[value] == null
                                        ? 'reports_heatmap_no_lectures'.i18n()
                                        : 'reports_heatmap_lectures_completed_snackbar_message'
                                            .i18n(
                                            [
                                              heatmap[value].toString(),
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
            const SizedBox(height: 10),
            Card(
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

                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : activeFolders.isEmpty
                            ? Center(
                                child: Text(
                                    'reports_active_folders_no_folders'.i18n()),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: activeFolders.length,
                                itemBuilder: (context, index) {
                                  return ActiveFolder(
                                    rank: index + 1,
                                    name: activeFolders[index],
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
