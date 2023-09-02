import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/util/date_format.dart';
import 'package:repet/widgets/lectures/lecture_action_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final dateNow = DateTime.now();
    final dayNow = DateTime(dateNow.year, dateNow.month, dateNow.day);

    var todayList =
        ref.read(lecturesProvider.notifier).fetchLecturesByDate(dayNow);

    var tomorrowList = ref.watch(lecturesProvider.notifier).fetchLecturesByDate(
          dayNow.copyWith(day: dayNow.day + 1),
        );

    var overdueList =
        ref.watch(lecturesProvider.notifier).fetchLecturesBeforeDate(dayNow);
    var isOverdue = overdueList.isNotEmpty;

    ref.listen(lecturesProvider, (previous, next) {
      todayList =
          ref.read(lecturesProvider.notifier).fetchLecturesByDate(dayNow);
      tomorrowList = ref.watch(lecturesProvider.notifier).fetchLecturesByDate(
            dayNow.copyWith(day: dayNow.day + 1),
          );
      overdueList =
          ref.watch(lecturesProvider.notifier).fetchLecturesBeforeDate(dayNow);
      isOverdue = overdueList.isNotEmpty;
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isOverdue
                ? Text(
                    'Overdue',
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.error),
                  )
                : Container(),
            isOverdue
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: overdueList.length,
                    itemBuilder: (context, index) => LectureActionItem(
                      lecture: overdueList[index],
                      due: -1,
                      // There are problems updating the overdue list just by
                      // notifying the state of the lectures provider, that's
                      // why this method will update the list internally
                      updateLectureLists: () => setState(() {
                        overdueList = ref
                            .watch(lecturesProvider.notifier)
                            .fetchLecturesBeforeDate(dayNow);
                      }),
                    ),
                  )
                : Container(),
            isOverdue ? const SizedBox(height: 12) : Container(),
            Text(
              'Today | ${MultipleDateFormat.simpleYearFormatDate(dateNow)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 12),
            todayList.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'No lectures due today!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: todayList.length,
                    itemBuilder: (context, index) => LectureActionItem(
                      lecture: todayList[index],
                      due: 0,
                      updateLectureLists: () => setState(() {
                        todayList = ref
                            .read(lecturesProvider.notifier)
                            .fetchLecturesByDate(dayNow);
                      }),
                    ),
                  ),
            const SizedBox(height: 12),
            Text(
              'Tomorrow | ${MultipleDateFormat.simpleYearFormatDate(
                dateNow.copyWith(
                  day: dateNow.day + 1,
                ),
              )}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 12),
            tomorrowList.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'No lectures due tomorrow!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tomorrowList.length,
                    itemBuilder: (context, index) =>
                        LectureActionItem(lecture: tomorrowList[index], due: 1),
                  ),
          ],
        ),
      ),
    );
  }
}
