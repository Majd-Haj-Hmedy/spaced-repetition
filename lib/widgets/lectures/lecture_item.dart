import 'package:flutter/material.dart';
import 'package:repet/models/lecture.dart';
import 'package:repet/screens/details.dart';
import 'package:repet/util/date_format.dart';
import 'package:repet/widgets/lectures/lecture_property.dart';

import '../../constants/colors.dart';

class LectureItem extends StatelessWidget {
  final Lecture lecture;

  const LectureItem({required this.lecture, super.key});

  static String getDifficultyText(Lecture lecture) {
    switch (lecture.difficulty) {
      case 0:
        return 'Easy';
      case 1:
        return 'Medium';
      default:
        return 'Hard';
    }
  }

  static Color getDifficultyColor(Lecture lecture) {
    switch (lecture.difficulty) {
      case 0:
        return RepetColors.difficulty_easy;
      case 1:
        return RepetColors.difficulty_medium;
      default:
        return RepetColors.difficulty_hard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LectureDetails(lecture: lecture),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lecture.name,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              LectureProperty(
                text: 'Stage ${lecture.currentStage}',
                icon: Icons.restart_alt,
                color: const Color.fromARGB(255, 82, 131, 235),
              ),
              const SizedBox(height: 6),
              LectureProperty(
                text: getDifficultyText(lecture),
                icon: Icons.psychology,
                color: getDifficultyColor(lecture),
              ),
              const SizedBox(height: 6),
              LectureProperty(
                text: MultipleDateFormat.simpleFormatDate(lecture.currentDate),
                icon: Icons.calendar_month,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
