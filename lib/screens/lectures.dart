import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/models/lecture.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/widgets/lectures/lecture_item.dart';

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
      isScrollControlled: true,
      builder: (context) => AddLecture(
        folderID: widget.folder.id,
        addLectureHandler: _addLecture,
      ),
    );
  }

  void _showEditLectureDialog(
      void Function(String name, int difficulty) editAction, Lecture lecture) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddLecture(
        folderID: widget.folder.id,
        renameLectureHandler: (chosenName, chosenDificulty) => editAction(
          chosenName,
          chosenDificulty,
        ),
        editedLecture: lecture,
      ),
    );
  }

  void _addLecture(
      String name, int difficulty, String folder, int stage, DateTime start) {
    setState(() {
      ref.read(lecturesProvider.notifier).addLecture(
            Lecture(
              name: name,
              difficulty: difficulty,
              folderID: folder,
              stage: stage,
              start: start,
            ),
          );
    });
  }

  List<Lecture> loadLectures() {
    return ref
        .watch(lecturesProvider.notifier)
        .fetchLecturesByFolder(widget.folder);
  }

  @override
  Widget build(BuildContext context) {
    var lectures = loadLectures();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLectureDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 210,
          mainAxisExtent: 200,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
        ),
        itemCount: lectures.length,
        itemBuilder: (context, index) => LectureItem(
          lecture: lectures[index],
          showRenameDialog: _showEditLectureDialog,
          reloadLecturesHandler: () => setState(() {
            lectures = loadLectures();
          }),
        ),
      ),
    );
  }
}
