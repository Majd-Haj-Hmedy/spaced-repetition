import 'package:flutter/material.dart';
import 'package:repet/data/dummy_data.dart';
import 'package:repet/widgets/folders/folder_dialog.dart';
import 'package:repet/widgets/folders/folder_item.dart';
import '../models/folder.dart';

enum FolderMode { add, edit }

// FIXME: Convert back to a stateless widget when Riverpod is implemented
class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  void _addFolder(Folder folder) {
    setState(() {
      dummyFolders.add(folder);
    });
  }

  void _renameFolder(Folder folder, String name) {
    setState(() {
      folder.name = name;
    });
  }

  void _removeFolder(Folder folder) {
    setState(() {
      dummyFolders.remove(folder);
    });
  }

  void _showFolderDialog(FolderMode mode, [Folder? folder, BuildContext? optionalContext]) {
    showDialog(
      context: optionalContext ?? context,
      builder: (ctx) => Dialog(
        child: FolderDialog(
          folderMode: mode,
          folderActionHandler: (name) => mode == FolderMode.add
              ? _addFolder(Folder(name: name))
              : _renameFolder(folder!, name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
          ),
          itemCount: dummyFolders.length,
          itemBuilder: (context, index) => FolderItem(
            folder: dummyFolders[index],
            removeFolderHandler: _removeFolder,
            renameDialogHandler: (folder) => _showFolderDialog(FolderMode.edit, folder, context),
          ),
        ),
        Positioned(
          bottom: 25,
          right: 25,
          child: FloatingActionButton(
            onPressed: () => _showFolderDialog(FolderMode.add),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
