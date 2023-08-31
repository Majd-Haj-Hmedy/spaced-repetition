import 'package:flutter/material.dart';
import 'package:repet/models/lecture.dart';
import 'package:repet/widgets/lectures/lecture_property.dart';

class LecturePreview extends StatelessWidget {
  final Lecture lecture;

  const LecturePreview({required this.lecture, super.key});

String get difficultyText {
  switch (lecture.difficulty) {
    case 0:
      return 'Easy';
    case 1:
      return 'Medium';
    default:
      return 'Hard';
  }
}

Color get difficultyColor {
  switch (lecture.difficulty) {
    case 0:
      return const Color.fromARGB(255, 73, 159, 104);
    case 1:
      return const Color.fromARGB(255, 255, 175, 33);
    default:
      return const Color.fromARGB(255, 221, 81, 71);
  }
}

@override
Widget build(BuildContext context) {
  return Card(

    child: Padding (
      padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lecture.name,
          style: Theme
              .of(context)
              .textTheme
              .bodyLarge,
        ),
        const SizedBox(height: 12),
        LectureProperty(
          // TODO: Replace with text: 'Stage ${lecture.current.keys.first}',
          text: 'Stage 3',
          icon: Icons.restart_alt,
          color: const Color.fromARGB(255, 82, 131, 235),
        ),
        const SizedBox(height: 6),
        LectureProperty(text: difficultyText, icon: Icons.home, color: difficultyColor),
        const SizedBox(height: 6),
        // TODO text: lecture.current.values.first.toString().substring(0, 8)
        // TODO: Format the date string
        LectureProperty(text: '22 Sep.', icon: Icons.calendar_month, color: const Color.fromARGB(255, 112, 112, 112),),
      ],
    ),
  ),);
}
}
