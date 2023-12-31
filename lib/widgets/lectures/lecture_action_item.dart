import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/util/lecture_difficulty.dart';
import 'package:repet/widgets/lectures/lecture_property.dart';
import '../../models/lecture.dart';
import '../../screens/details.dart';

class LectureActionItem extends ConsumerWidget {
  final Lecture lecture;
  final void Function()? updateLectureLists;

  /// This integer is used to differentiate overdue tasks from due today tasks and upcoming ones
  /// -1 refers to 'delayed'
  /// 0 refers to 'due today'
  /// 1 refers to 'due tomorrow'
  final int due;
  const LectureActionItem({
    required this.lecture,
    required this.due,
    this.updateLectureLists,
    super.key,
  });

  VoidCallback? _completeAction(BuildContext context, WidgetRef ref) {
    if (due == 0) {
      return () async {
        lecture.advance();
        final folderName = ref
            .read(foldersProvider.notifier)
            .getFolderByID(lecture.folderID)!
            .name;
        await ref.read(lecturesProvider.notifier).logCompletion(1, folderName);
        updateLectureLists!();
        await ref.read(lecturesProvider.notifier).stageAdvancement(lecture);
      };
    }

    if (due == 1) {
      return null;
    }

    return () {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: lecture.currentDate,
        lastDate: DateTime.now(),
      ).then((date) async {
        if (date != null) {
          lecture.lateAdvance(date);
          final folderName = ref
              .read(foldersProvider.notifier)
              .getFolderByID(lecture.folderID)!
              .name;
          await ref
              .read(lecturesProvider.notifier)
              .logCompletion(0, folderName);
          updateLectureLists!();
          await ref.read(lecturesProvider.notifier).stageAdvancement(lecture);
        }
      });
    };
  }

  VoidCallback? _skipAction(WidgetRef ref) {
    if (due == 0 || due == -1) {
      return () async {
        lecture.skip();
        final folderName = ref
            .read(foldersProvider.notifier)
            .getFolderByID(lecture.folderID)!
            .name;
        await ref.read(lecturesProvider.notifier).logCompletion(-1, folderName);
        updateLectureLists!();
        await ref.read(lecturesProvider.notifier).stageAdvancement(lecture);
      };
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lectureFolder =
        ref.watch(foldersProvider.notifier).getFolderByID(lecture.folderID)!;
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
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Text(
                      lecture.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            // This code checks if the lecture is overdue in which case the
                            // the lecture name color is set to red
                            color: due == -1
                                ? Theme.of(context).colorScheme.error
                                : null,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LectureProperty(
                    text: 'home_lecture_stage'.i18n(
                      [
                        '${lecture.currentStage}',
                      ],
                    ),
                    icon: Icons.restart_alt,
                    color: const Color.fromARGB(255, 82, 131, 235),
                  ),
                  const SizedBox(height: 6),
                  LectureProperty(
                    text: LectureDifficulty.getDifficultyText(lecture),
                    icon: Icons.psychology,
                    color: LectureDifficulty.getDifficultyColor(lecture),
                  ),
                  const SizedBox(height: 6),
                  LectureProperty(
                    text: lectureFolder.name,
                    icon: Icons.folder,
                    color: Colors.grey,
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _completeAction(context, ref),
                icon: Icon(due == -1 ? Icons.history : Icons.check),
                label: Text('home_lecture_complete'.i18n()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: due == -1
                      ? const Color(0xFFF7b217)
                      : Theme.of(context).colorScheme.primary,
                  foregroundColor: due == -1
                      ? Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 110, 78, 5)
                          : Colors.white
                      : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              PopupMenuButton(
                enabled: due != 1,
                icon: const Icon(
                  Icons.arrow_drop_down,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: _skipAction(ref),
                    child: Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'home_lecture_skip'.i18n(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
