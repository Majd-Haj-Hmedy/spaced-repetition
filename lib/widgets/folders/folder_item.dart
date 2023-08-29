import 'package:flutter/material.dart';
import 'package:repet/models/folder.dart';

class FolderItem extends StatelessWidget {
  final Folder folder;
  final void Function(Folder folder) removeFolderHandler;
  final void Function(Folder folder) renameDialogHandler;
  const FolderItem({
    required this.folder,
    required this.removeFolderHandler,
    required this.renameDialogHandler,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox(
                  width: 80,
                  child: Text(
                    folder.name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: const Text('Edit'),
                    // FIXME: Set new name dynamically based on user input
                    onTap: () => renameDialogHandler(folder),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: const Text('Delete'),
                    onTap: () => removeFolderHandler(folder),
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
