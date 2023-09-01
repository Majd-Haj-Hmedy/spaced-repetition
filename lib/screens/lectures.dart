import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/models/lecture.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/widgets/lectures/lecture_preview.dart';

import '../models/folder.dart';
import '../widgets/lectures/add_lecture.dart';

class LecturesScreen extends ConsumerStatefulWidget {
  final Folder folder;

  const LecturesScreen({required this.folder, super.key});

  @override
  ConsumerState<LecturesScreen> createState() {
    return _LecturesScreenState();
  }
}

class _LecturesScreenState extends ConsumerState<LecturesScreen> {
  void _showAddLectureDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddLecture(folderName: widget.folder.name, addLectureHandler: _addLecture),
    );
  }

  void _addLecture(String name, int difficulty, String folder) {
    setState(() {
      setState(() {
        ref.read(lecturesProvider.notifier).addLecture(
              Lecture(name: name, difficulty: difficulty, folder: folder),
            );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final lectures = ref
        .watch(lecturesProvider.notifier)
        .fetchLecturesByFolder(widget.folder);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
      ),
      floatingActionButton: FloatingActionButton(
        // TODO: Implement the Add 'Lecture screen' and launch it
        onPressed: () {
          _showAddLectureDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: lectures.length,
        itemBuilder: (context, index) =>
            LecturePreview(lecture: lectures[index]),
      ),
    );
  }
}
