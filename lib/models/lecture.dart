import 'package:uuid/uuid.dart';

class Lecture {
  final String id;
  String name;
  final String folder;
  final int difficulty;
  final Map<int, DateTime> current;
  final Map<int, DateTime> dates;
  final Map<int, DateTime> stagesHistory;

  Lecture({
    required this.name,
    required this.difficulty,
    required this.folder,
  })  : id = const Uuid().v4(),
        current = {},
        dates = {},
        stagesHistory = {};

  Map<int, DateTime> createDefaultPlan(DateTime start) {
    dates[1] = DateTime(start.year, start.month, start.day);
    dates[2] = DateTime(start.year, start.month, start.day + 2);
    dates[3] = DateTime(start.year, start.month, start.day + 6);
    dates[4] = DateTime(start.year, start.month, start.day + 13);
    dates[5] = DateTime(start.year, start.month, start.day + 29);
    return dates;
  }
}
