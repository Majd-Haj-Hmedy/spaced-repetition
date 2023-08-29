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
}

final foldersProvider =
    StateNotifierProvider<FoldersStateNotifier, List<Folder>>(
  (ref) => FoldersStateNotifier(),
);
