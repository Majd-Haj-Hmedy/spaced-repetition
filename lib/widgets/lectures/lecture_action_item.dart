import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/util/lecture_difficulty.dart';
import 'package:repet/widgets/lectures/lecture_property.dart';
import '../../models/lecture.dart';
import '../../screens/details.dart';

class LectureActionItem extends ConsumerWidget {
  final Lecture lecture;
  final void Function()? updateOverdueList;

  /// This integer is used to differentiate overdue tasks from due today tasks and upcoming ones
  /// -1 refers to 'delayed'
  /// 0 refers to 'due today'
  /// 1 refers to 'due tomorrow'
  final int due;
  const LectureActionItem({
    required this.lecture,
    required this.due,
    this.updateOverdueList,
    super.key,
  });

  VoidCallback? _completeAction(BuildContext context, WidgetRef ref) {
    if (due == 0) {
      return () {
        lecture.advance();
        ref.read(lecturesProvider.notifier).notifyState();
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
      ).then((date) {
        lecture.lateAdvance(date ?? DateTime.now());
        updateOverdueList!();
      });
    };
  }

  VoidCallback? _skipAction(WidgetRef ref) {
    if (due == 0 || due == -1) {
      return () {
        lecture.skip();
        ref.read(lecturesProvider.notifier).notifyState();
      };
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lectureFolder = ref.watch(foldersProvider.notifier).getFolderByID(lecture.folderID)!;
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
                  Text(
                    lecture.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          // This code checks if the lecture is overdue in which case the
                          // the lecture name color is set to red
                          color: due == -1
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
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
                icon: const Icon(Icons.check),
                label: const Text('Complete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                          'Skip',
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
