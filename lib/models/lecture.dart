import 'package:uuid/uuid.dart';

class Lecture {
  final String id;
  String name;
  final String folderID;
  int difficulty;

  int currentStage;
  DateTime currentDate;

  /*
  This map stores all the entries in which the lecture should move
  through the stages that are left
  */
  final Map<int, DateTime> dates;

  /*
  This map stores all the entries in which the lecture had already moved
  through, the date is used to check whether the stage was completed in-time,
  delayed, or not done (in which the dateTime object is null)
  */
  final Map<int, DateTime?> stagesHistory;

  Lecture.loaded({
    required this.id,
    required this.name,
    required this.folderID,
    required this.difficulty,
    required this.currentStage,
    required this.currentDate,
    required this.dates,
    required this.stagesHistory,
  });

  Lecture({
    required this.name,
    required this.difficulty,
    required this.folderID,
    required DateTime start,
    required int stage,
  })  : id = const Uuid().v4(),
        dates = {},
        stagesHistory = {},
        // The following two lines are only temporary and are both overridden in the
        // class constructor body
        currentStage = 0,
        currentDate = DateTime.now() {
    // This for loop runs 5 times, each time it assigns an appending value based
    // on the corresponding stage the variable 'i' points to (This integer is
    // used to add a fixed amount of days to each stage so as to adhere to the
    // concept of spaced repetition)

    // After that, if 'i' is less than the stage passed to the constructor, it's
    // a stage in the past and therefore assigned to the stages history, otherwise,
    // it's assigned to the dates map which holds future stages and their
    // corresponding dates
    for (int i = 1; i <= 5; i++) {
      var dayAppend = 0;
      switch (i) {
        case 1:
          dayAppend = 0;
          break;
        case 2:
          dayAppend = 2;
          break;
        case 3:
          dayAppend = 6;
          break;
        case 4:
          dayAppend = 13;
          break;
        case 5:
          dayAppend = 29;
          break;
      }
      if (i < stage) {
        dates[i] = DateTime(start.year, start.month, start.day + dayAppend);
        stagesHistory[i] =
            DateTime(start.year, start.month, start.day + dayAppend);
      } else {
        dates[i] = DateTime(start.year, start.month, start.day + dayAppend);
        stagesHistory[i] = DateTime(2001, 9, 11);
      }
    }
    currentStage = stage;
    currentDate = dates[stage]!;
  }

  int getStageStatus(int stage) {
    return stagesHistory[stage]!.compareTo(dates[stage]!);
  }

  void advance() {
    final dateNow = DateTime.now();
    final dayNow = DateTime(dateNow.year, dateNow.month, dateNow.day);
    stagesHistory[currentStage] = dayNow;
    if (currentStage < 5) {
      ++currentStage;
      currentDate = dates[currentStage]!;
    }
  }

  void lateAdvance(DateTime date) {
    final storedDate = DateTime(date.year, date.month, date.day);
    stagesHistory[currentStage] = storedDate;
    final delay = storedDate.difference(dates[currentStage]!);
    if (currentStage < 5) {
      ++currentStage;
      currentDate = dates[currentStage]!;

      for (int i = currentStage; i <= 5; i++) {
        dates[i] = dates[i]!.add(delay);
      }
    }
  }

  void skip() {
    stagesHistory[currentStage] = null;
    if (currentStage < 5) {
      ++currentStage;
      currentDate = dates[currentStage]!;
    }
  }
}
