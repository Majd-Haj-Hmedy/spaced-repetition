import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    lecturesList = [
      ...ref
          .read(lecturesProvider.notifier)
          .fetchLecturesBeforeDate(_selectedDate),
      ...ref.read(lecturesProvider.notifier).fetchLecturesByDate(_selectedDate)
    ];
    super.initState();
  }

  List<Lecture> getLectures() {
    // If the date is today's date, then overdue lectures will be included as well
    if (_selectedDate.compareTo(dateNow) == 0) {
      // A list will be returned containing the overdue lectures at first, and the
      // due today lectures afterwards
      return [
        ...ref
            .read(lecturesProvider.notifier)
            .fetchLecturesBeforeDate(_selectedDate),
        ...ref
            .read(lecturesProvider.notifier)
            .fetchLecturesByDate(_selectedDate)
      ];
    } else {
      return ref
          .read(lecturesProvider.notifier)
          .fetchLecturesByDate(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Handle overdue lectures
    lecturesList = getLectures();

    return Column(
      children: [
        TableCalendar(
          focusedDay: _selectedDate,
          firstDay: dateNow,
          lastDay: DateTime(dateNow.year, 12, 31),
          calendarFormat: CalendarFormat.week,
          /*
          Although the following code may seem redundant, this approach seems like
          the only one to replace the formater button with a button that sets the
          current date to today's
          */
          availableCalendarFormats: const {
            CalendarFormat.week: 'Today',
            CalendarFormat.month: 'Today',
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
        lecturesList.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    'No lectures!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: lecturesList.length,
                  itemBuilder: (context, index) => LectureActionItem(
                    lecture: lecturesList[index],
                    // The following code has a nested if else statement written
                    // as ternary operators,
                    // the first statement checks if the date is today or tomorrow
                    // if it's today, then the lectures dates are checked to see
                    // if they're overdue or not
                    due: _selectedDate.compareTo(DateTime.now().removeTime()) ==
                            0
                        ? lecturesList[index].currentDate.compareTo(dateNow) ==
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
      ],
    );
  }
}

extension DateTimeExtension on DateTime {
  DateTime removeTime() {
    return DateTime(year, month, day);
  }
}
