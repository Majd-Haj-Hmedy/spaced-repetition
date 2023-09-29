import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/util/date_format.dart';
import 'package:repet/util/lecture_difficulty.dart';
import 'package:repet/widgets/lectures/detailed_property.dart';
import 'package:repet/widgets/lectures/progress_overview.dart';

import '../models/lecture.dart';

class LectureDetails extends ConsumerWidget {
  final Lecture lecture;
  const LectureDetails({required this.lecture, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lectureFolder =
        ref.watch(foldersProvider.notifier).getFolderByID(lecture.folderID)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(lecture.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            DetailedLectureProperty(
              description: 'lecture_details_difficulty'.i18n(),
              value: LectureDifficulty.getDifficultyText(lecture),
              color: LectureDifficulty.getDifficultyColor(lecture),
            ),
            const SizedBox(height: 8),
            DetailedLectureProperty(
              description: 'lecture_details_folder'.i18n(),
              value: lectureFolder.name,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            DetailedLectureProperty(
              description: 'lecture_details_start_date'.i18n(),
              value: MultipleDateFormat.simpleYearFormatDate(
                lecture.dates[1]!,
                context,
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            DetailedLectureProperty(
              description: 'lecture_details_due_date'.i18n(),
              value: MultipleDateFormat.simpleYearFormatDate(
                lecture.dates[5]!,
                context,
              ),
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            Text(
              'lecture_details_repetition_overview'.i18n(),
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).disabledColor),
            ),
            ProgressOverview(lecture: lecture),
          ],
        ),
      ),
    );
  }
}
