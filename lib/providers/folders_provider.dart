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
    if (state.where((element) => element.name == folder.name).isNotEmpty) {
      // This simple recursion runs addFolder with the appendix '*' to
      // make sure that no multiple folders share the same name with that appendix
      addFolder(Folder(name: '${folder.name}*'));
    } else {
      state = [...state, folder];
    }
  }

  void removeFolder(Folder folder) {
    state = state.where((element) => element != folder).toList();
  }

  void renameFolder(Folder folder, String name) {
    if (state.where((element) => element.name == name).isNotEmpty) {
      renameFolder(folder, '$name*');
    } else {
      folder.name = name;
      state = [...state];
    }
  }

  Folder? getFolderByName(String name) {
    return state.where((element) => element.name == name).toList()[0];
  }

  Folder? getFolderByID(String id) {
    return state.where((element) => element.id == id).toList()[0];
  }
}

final foldersProvider =
    StateNotifierProvider<FoldersStateNotifier, List<Folder>>(
  (ref) => FoldersStateNotifier(),
);
