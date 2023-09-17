import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/data/database_helper.dart';
import 'package:repet/models/folder.dart';
import 'package:repet/models/lecture.dart';
import 'package:repet/util/date_format.dart';
import 'package:sqflite/sqflite.dart';

class LecturesStateNotifier extends StateNotifier<List<Lecture>> {
  late Database db;
  LecturesStateNotifier() : super([]);

  Future<void> loadLectures() async {
    db = await DatabaseHelper.getDatabase();
    db.query('lectures').then(
      (queriedLectures) {
        final lecturesList = <Lecture>[];
        for (final row in queriedLectures) {
          final datesMap = <int, DateTime>{};
          final historyMap = <int, DateTime?>{};
          for (int i = 1; i <= 5; i++) {
            datesMap[i] = MultipleDateFormat.simpleYearParseString(
                row['date$i'] as String);
            if (row['history$i'] != null) {
              historyMap[i] = MultipleDateFormat.simpleYearParseString(
                  row['history$i'] as String);
            }
          }
          lecturesList.add(
            Lecture.loaded(
              id: row['id'] as String,
              name: row['name'] as String,
              folderID: row['folder_id'] as String,
              difficulty: row['difficulty'] as int,
              currentStage: row['current_stage'] as int,
              currentDate: MultipleDateFormat.simpleYearParseString(
                  row['current_date'] as String),
              dates: datesMap,
              stagesHistory: historyMap,
            ),
          );
        }
        state = lecturesList;
      },
    );
  }

  void addLecture(Lecture lecture) async {
    state = [...state, lecture];
    await db.insert(
      'lectures',
      {
        'id': lecture.id,
        'name': lecture.name,
        'difficulty': lecture.difficulty,
        'folder_id': lecture.folderID,
        'current_stage': lecture.currentStage,
        'current_date':
            MultipleDateFormat.simpleYearFormatDate(lecture.currentDate),
        'date1': MultipleDateFormat.simpleYearFormatDate(lecture.dates[1]!),
        'date2': MultipleDateFormat.simpleYearFormatDate(lecture.dates[2]!),
        'date3': MultipleDateFormat.simpleYearFormatDate(lecture.dates[3]!),
        'date4': MultipleDateFormat.simpleYearFormatDate(lecture.dates[4]!),
        'date5': MultipleDateFormat.simpleYearFormatDate(lecture.dates[5]!),
        'history1': lecture.stagesHistory[1] != null
            ? MultipleDateFormat.simpleYearFormatDate(lecture.stagesHistory[1]!)
            : null,
        'history2': lecture.stagesHistory[2] != null
            ? MultipleDateFormat.simpleYearFormatDate(lecture.stagesHistory[2]!)
            : null,
        'history3': lecture.stagesHistory[3] != null
            ? MultipleDateFormat.simpleYearFormatDate(lecture.stagesHistory[3]!)
            : null,
        'history4': lecture.stagesHistory[4] != null
            ? MultipleDateFormat.simpleYearFormatDate(lecture.stagesHistory[4]!)
            : null,
        'history5': lecture.stagesHistory[5] != null
            ? MultipleDateFormat.simpleYearFormatDate(lecture.stagesHistory[5]!)
            : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void deleteLecture(Lecture lecture) async {
    state = state.where((element) => lecture != element).toList();
    await db.delete('lectures', where: 'id = ?', whereArgs: [lecture.id]);
  }

  void editLecture(Lecture lecture, String name, int difficulty) async {
    lecture.name = name;
    lecture.difficulty = difficulty;
    state = [...state];

    await db.update(
      'lectures',
      {
        'name': lecture.name,
        'difficulty': lecture.difficulty,
      },
      where: 'id = ?',
      whereArgs: [lecture.id],
    );
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

  Future<void> stageAdvancement(Lecture lecture) async {
    await db.update(
      'lectures',
      {
        'current_stage': lecture.currentStage,
        'current_date': MultipleDateFormat.simpleYearFormatDate(
          lecture.currentDate,
        ),
        'date1': MultipleDateFormat.simpleYearFormatDate(lecture.dates[1]!),
        'date2': MultipleDateFormat.simpleYearFormatDate(lecture.dates[2]!),
        'date3': MultipleDateFormat.simpleYearFormatDate(lecture.dates[3]!),
        'date4': MultipleDateFormat.simpleYearFormatDate(lecture.dates[4]!),
        'date5': MultipleDateFormat.simpleYearFormatDate(lecture.dates[5]!),
        'history${lecture.currentStage - 1}':
            lecture.stagesHistory[lecture.currentStage - 1] != null
                ? MultipleDateFormat.simpleYearFormatDate(
                    lecture.stagesHistory[lecture.currentStage - 1]!)
                : null,
      },
      where: 'id = ?',
      whereArgs: [lecture.id],
    );
  }
}

final lecturesProvider =
    StateNotifierProvider<LecturesStateNotifier, List<Lecture>>(
        (ref) => LecturesStateNotifier());
