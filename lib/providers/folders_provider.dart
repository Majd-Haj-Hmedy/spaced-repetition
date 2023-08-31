import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/models/folder.dart';

class FoldersStateNotifier extends StateNotifier<List<Folder>> {
  FoldersStateNotifier() : super([]);

  void loadFoldersFromDB() {
    // TODO: Load folders
  }

  void saveFoldersToDB() {
    // TODO: Save folders
  }

  void addFolder(Folder folder) {
    state = [...state, folder];
  }

  void removeFolder(Folder folder) {
    state = state.where((element) => element != folder).toList();
  }

  void renameFolder(Folder folder, String name) {
    folder.name = name;
    state = [...state];
  }

  Folder getFolderByName(String name) {
    return state.where((element) => element.name == name).toList()[0];
  }
}

final foldersProvider =
    StateNotifierProvider<FoldersStateNotifier, List<Folder>>(
  (ref) => FoldersStateNotifier(),
);
