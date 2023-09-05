import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/data/database_helper.dart';
import 'package:repet/models/folder.dart';
import 'package:sqflite/sqflite.dart';

class FoldersStateNotifier extends StateNotifier<List<Folder>> {
  late Database db;
  FoldersStateNotifier() : super([]);

  Future<void> loadFolders() async {
    // This is the first method to excute so db will always be initalized before usage
    db = await DatabaseHelper.getDatabase();
    final rows = await db.query('folders');
    final loadedFolders = <Folder>[];
    for (final row in rows) {
      loadedFolders.add(
        Folder.loaded(id: row['id'] as String, name: row['name'] as String),
      );
    }
    state = loadedFolders;
  }

  void addFolder(Folder folder) {
    if (state.where((element) => element.name == folder.name).isNotEmpty) {
      // This simple recursion runs addFolder with the appendix '*' to
      // make sure that no multiple folders share the same name with that appendix
      addFolder(Folder(name: '${folder.name}*'));
    } else {
      state = [...state, folder];
      db.insert(
        'folders',
        {
          'id': folder.id,
          'name': folder.name,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  void removeFolder(Folder folder) {
    db.delete(
      'folders',
      where: 'id = ?',
      whereArgs: [folder.id],
    ).then(
      (value) => state = state.where((element) => element != folder).toList(),
    );
  }

  void renameFolder(Folder folder, String name) {
    if (state.where((element) => element.name == name).isNotEmpty) {
      renameFolder(folder, '$name*');
    } else {
      db
          .update(
        'folders',
        {'name': name},
        where: 'id = ?',
        whereArgs: [folder.id],
      )
          .then((value) {
        folder.name = name;
        state = [...state];
      });
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
