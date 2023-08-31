import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/models/lecture.dart';
import 'package:repet/providers/lectures_provider.dart';

import '../models/folder.dart';

class LecturesScreen extends ConsumerStatefulWidget {
  final Folder folder;
  const LecturesScreen({required this.folder, super.key});
  @override
  ConsumerState<LecturesScreen> createState() {
    return _LecturesScreenState();
  }
}
class _LecturesScreenState extends ConsumerState<LecturesScreen> {
  @override
  Widget build(BuildContext context) {
    final lectures = ref.watch(lecturesProvider.notifier).fetchLecturesByFolder(widget.folder);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
      ),
      floatingActionButton: FloatingActionButton(
        // TODO: Implement the Add 'Lecture screen' and launch it
        onPressed: () {
          setState(() {
            ref.read(lecturesProvider.notifier).addLecture(Lecture(name: 'Test', difficulty: 0, folder: 'Anatomy'),);
          });
        },
        child: const Icon(Icons.add),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
        ),
        itemCount: lectures.length,
        itemBuilder: (context, index) => Text(
          lectures[index].name,
        ),
      ),
    );
  }
}
