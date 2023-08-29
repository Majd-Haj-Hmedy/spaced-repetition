import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/models/folder.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/screens/folders.dart';
import 'package:repet/widgets/folders/folder_dialog.dart';

class FolderItem extends ConsumerWidget {
  final Folder folder;
  FolderItem({
    required this.folder,
    super.key,
  });

  late WidgetRef widRef;

  void _deleteFolder() {
    widRef.read(foldersProvider.notifier).removeFolder(folder);
  }

  void _renameFolder(Folder folder, String name) {
    widRef.read(foldersProvider.notifier).renameFolder(folder, name);
  }

  void _showRenameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FolderDialog(
          folderMode: FolderMode.edit,
          folderActionHandler: (name) => _renameFolder(folder, name),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: const Text(
            'This folder and its content can NOT be retrieved\nDo you want to proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteFolder();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    widRef = ref;
    return InkWell(
      // TODO: Open lectures screen
      onTap: () => null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.folder,
            color: Theme.of(context).colorScheme.primary,
            size: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FIXME: Text is not centered
              const Spacer(),
              Flexible(
                child: Text(
                  folder.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                onSelected: (value) => value == 0
                    ? _showRenameDialog(context)
                    : _showDeleteDialog(context),
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
