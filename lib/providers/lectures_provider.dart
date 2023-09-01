import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/models/folder.dart';
import 'package:repet/models/lecture.dart';

class LecturesStateNotifier extends StateNotifier<List<Lecture>> {
  LecturesStateNotifier() : super([]);

  void addLecture(Lecture lecture) {
    state = [...state, lecture];
  }

  void deleteLecture(Lecture lecture) {
    state = state.where((element) => lecture != element).toList();
  }

  void renameLecture(Lecture lecture, String name) {
    lecture.name = name;
    state = [...state];
  }

  List<Lecture> fetchLecturesByFolder(Folder folder) {
    return state.where((element) => element.folder == folder.name).toList();
  }

  void advanceLecture(Lecture lecture) {
    lecture.advance();
    state = [...state];
  }
}

final lecturesProvider =
    StateNotifierProvider<LecturesStateNotifier, List<Lecture>>(
        (ref) => LecturesStateNotifier());
