import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/widgets/folders/folder_dialog.dart';
import 'package:repet/widgets/folders/folder_item.dart';
import '../models/folder.dart';

enum FolderMode { add, edit }

class FoldersScreen extends ConsumerStatefulWidget {
  const FoldersScreen({super.key});

  @override
  ConsumerState<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends ConsumerState<FoldersScreen> {
  void _addFolder(Folder folder) {
    final foldersNotifier = ref.read(foldersProvider.notifier);
    foldersNotifier.addFolder(folder);
  }

  void _showAddFolderDialog(FolderMode mode) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: FolderDialog(
          folderMode: mode,
          folderActionHandler: (name) => _addFolder(
            Folder(name: name),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final folders = ref.watch(foldersProvider);
    return Stack(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) => FolderItem(
            folder: folders[index],
          ),
        ),
        Positioned(
          bottom: 25,
          right: 25,
          child: FloatingActionButton(
            onPressed: () => _showAddFolderDialog(FolderMode.add),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
