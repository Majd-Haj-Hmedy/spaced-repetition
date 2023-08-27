import 'package:uuid/uuid.dart';

class Folder {
  late String id;
  final String name;
  late List<String> lectures;
  Folder({required this.name, List<String>? lectures}) {
    if (lectures != null) {
      this.lectures = lectures;
      id = const Uuid().v4();
    }
  }
}
