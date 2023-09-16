import 'package:flutter/material.dart';
import 'package:repet/models/lecture.dart';
import 'package:repet/util/date_format.dart';
import 'package:repet/widgets/lectures/progress_item.dart';

class ProgressOverview extends StatelessWidget {
  final Lecture lecture;
  const ProgressOverview({
    required this.lecture,
    super.key,
  });

  int stageState(int index) {
    // '-1' Refers to 'not known yet'
    // '0' refers to 'skipped'
    // '1' refers to 'delayed'
    // '2' refers to 'done in time'

    // The date of the event 9/11 is used to check if there's no data assigned
    // to a particular stage
    if (lecture.stagesHistory[index + 1] == null) {
      return 0;
    }
    if (lecture.stagesHistory[index + 1]!.compareTo(DateTime(2001, 9, 11)) ==
        0) {
      return -1;
    }
    if (lecture.stagesHistory[index + 1]!
            .compareTo(lecture.dates[index + 1]!) ==
        0) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ProgressItem(
          index: index,
          status: stageState(index),
          date: MultipleDateFormat.simpleFormatDate(lecture.dates[index + 1]!),
          delayedDate: stageState(index) == 1
              ? MultipleDateFormat.simpleFormatDate(
                  lecture.stagesHistory[index + 1]!,
                )
              : null,
        ),
      ),
    );
  }
}
