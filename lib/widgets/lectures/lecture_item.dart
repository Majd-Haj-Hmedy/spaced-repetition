import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/models/lecture.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/screens/details.dart';
import 'package:repet/util/date_format.dart';
import 'package:repet/widgets/lectures/lecture_property.dart';
import '../../util/lecture_difficulty.dart';

class LectureItem extends ConsumerWidget {
  final Lecture lecture;
  final void Function(
    void Function(String name, int difficulty),
    Lecture lecture,
  ) showRenameDialog;

  final VoidCallback reloadLecturesHandler;
  final bool firstLaunch;

  const LectureItem({
    required this.lecture,
    required this.showRenameDialog,
    required this.reloadLecturesHandler,
    required this.firstLaunch,
    super.key,
  });

  void _showDeleteLectureDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: const Text(
            'This folder and its content can NOT be retrieved\nDo you want to proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(lecturesProvider.notifier).deleteLecture(lecture);
              reloadLecturesHandler();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openLectureDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LectureDetails(lecture: lecture),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () =>_openLectureDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 80),
                    child: Text(
                      lecture.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 0) {
                        return showRenameDialog((name, difficulty) {
                          ref
                              .read(lecturesProvider.notifier)
                              .editLecture(lecture, name, difficulty);
                          reloadLecturesHandler();
                        }, lecture);
                      }
                      return _showDeleteLectureDialog(context, ref);
                    },
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
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
                text: MultipleDateFormat.simpleFormatDate(
                    lecture.currentDate),
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
