import 'package:uuid/uuid.dart';

class Folder {
  late String id;
  String name;
  Folder({required this.name}) : id = const Uuid().v4();
  Folder.loaded({required this.id, required this.name});
}
