import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/lecture.dart';
import '../widgets/lectures/lecture_action_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final dateNow = DateTime.now().removeTime();
  late DateTime _selectedDate;
  var lecturesList = <Lecture>[];

  @override
  void initState() {
    _selectedDate = dateNow;
    super.initState();
  }

  Future<void> getLectures() async {
    // If the date is today's date, then overdue lectures will be included as well
    if (_selectedDate.compareTo(dateNow) == 0) {
      // A list will be returned containing the overdue lectures at first, and the
      // due today lectures afterwards
      return Future(() {
        lecturesList = [
          ...ref
              .read(lecturesProvider.notifier)
              .fetchLecturesBeforeDate(_selectedDate),
          ...ref
              .read(lecturesProvider.notifier)
              .fetchLecturesByDate(_selectedDate)
        ];
      });
    }
    return Future(() {
      lecturesList = ref
          .read(lecturesProvider.notifier)
          .fetchLecturesByDate(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fix for the widget building with no data in the list
    return FutureBuilder(
      future: getLectures(),
      builder: (context, snapshot) {
        return Column(
          children: [
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: dateNow,
              lastDay: dateNow.add(const Duration(days: 365)),
              calendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(
                disabledTextStyle: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
              ),
              locale: Localizations.localeOf(context).languageCode,
              /*
                Although the following code may seem redundant, this approach seems like
                the only one to replace the formater button with a button that sets the
                current date to today's
            */
              availableCalendarFormats: {
                CalendarFormat.week: 'home_calendar_today'.i18n(),
                CalendarFormat.month: 'home_calendar_today'.i18n(),
              },
              onFormatChanged: (format) {
                setState(() {
                  _selectedDate = DateTime.now().removeTime();
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDate, selectedDay)) {
                  setState(() {
                    _selectedDate = selectedDay.removeTime();
                  });
                }
              },
              weekendDays: const [],
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                formatButtonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Divider(),
            snapshot.connectionState == ConnectionState.waiting
                ? const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator.adaptive())
                : lecturesList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          'No lectures!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _selectedDate = _selectedDate;
                            });
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            itemCount: lecturesList.length,
                            itemBuilder: (context, index) => LectureActionItem(
                              lecture: lecturesList[index],
                              // The following code has a nested if else statement written
                              // as ternary operators,
                              // the first statement checks if the date is today or tomorrow
                              // if it's today, then the lectures dates are checked to see
                              // if they're overdue or not
                              due: _selectedDate.compareTo(
                                          DateTime.now().removeTime()) ==
                                      0
                                  ? lecturesList[index]
                                              .currentDate
                                              .compareTo(dateNow) ==
                                          0
                                      ? 0
                                      : -1
                                  : 1,
                              updateLectureLists: () => setState(() {
                                lecturesList = ref
                                    .read(lecturesProvider.notifier)
                                    .fetchLecturesByDate(_selectedDate);
                              }),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}

extension DateTimeExtension on DateTime {
  DateTime removeTime() {
    return DateTime(year, month, day);
  }
}
