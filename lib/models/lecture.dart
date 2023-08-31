import 'package:uuid/uuid.dart';

class Lecture {
  final String id;
  String name;
  final String folder;
  final int difficulty;
  final Map<int, DateTime> currentStage;
  final List<Map<int, DateTime>> dates;
  final List<Map<int, DateTime>> stagesHistory;

  Lecture({
    required this.name,
    required this.difficulty,
    required this.folder,
  })  : id = const Uuid().v4(),
        currentStage = {},
        dates = [],
        stagesHistory = [];

  List<Map<int, DateTime>> createDefaultPlan(DateTime start) {
    dates.add({1: DateTime(start.year, start.month, start.day)});
    dates.add({1: DateTime(start.year, start.month, start.day + 2)});
    dates.add({1: DateTime(start.year, start.month, start.day + 6)});
    dates.add({1: DateTime(start.year, start.month, start.day + 13)});
    dates.add({1: DateTime(start.year, start.month, start.day + 29)});
    return dates;
  }
}
