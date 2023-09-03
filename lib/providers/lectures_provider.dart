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

  void editLecture(Lecture lecture, String name, int difficulty) {
    lecture.name = name;
    lecture.difficulty = difficulty;
    state = [...state];
  }

  List<Lecture> fetchLecturesByFolder(Folder folder) {
    return state.where((element) => element.folderID == folder.id).toList();
  }

  List<Lecture> fetchLecturesByDate(DateTime date) {
    return state
        .where((lecture) => lecture.currentDate.compareTo(date) == 0)
        .toList();
  }

  List<Lecture> fetchLecturesBeforeDate(DateTime date) {
    return state
        .where((lecture) => lecture.currentDate.compareTo(date) < 0)
        .toList();
  }

  void advanceLecture(Lecture lecture) {
    lecture.advance();
    state = [...state];
  }

  void notifyState() {
    state = [...state];
  }
}

final lecturesProvider =
    StateNotifierProvider<LecturesStateNotifier, List<Lecture>>(
        (ref) => LecturesStateNotifier());
