import 'package:flutter/material.dart';
import 'package:repet/util/date_format.dart';
import 'package:repet/util/lecture_difficulty.dart';
import 'package:repet/widgets/lectures/detailed_property.dart';
import 'package:repet/widgets/lectures/progress_overview.dart';

import '../models/lecture.dart';

class LectureDetails extends StatelessWidget {
  final Lecture lecture;
  const LectureDetails({required this.lecture, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lecture.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            DetailedLectureProperty(
              description: 'Difficulty',
              value: LectureDifficulty.getDifficultyText(lecture),
              color: LectureDifficulty.getDifficultyColor(lecture),
            ),
            const SizedBox(height: 8),
            DetailedLectureProperty(
              description: 'Folder',
              value: lecture.folder,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            DetailedLectureProperty(
              description: 'Start date',
              value: MultipleDateFormat.simpleYearFormatDate(lecture.dates[1]!),
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            DetailedLectureProperty(
              description: 'Due date',
              value: MultipleDateFormat.simpleYearFormatDate(lecture.dates[5]!),
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            const Text(
              'Repetition overview',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            ProgressOverview(lecture: lecture),
          ],
        ),
      ),
    );
  }
}
