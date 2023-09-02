import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/screens/folders.dart';

class FolderDialog extends ConsumerStatefulWidget {
  final FolderMode folderMode;
  final void Function(String name) folderActionHandler;
  const FolderDialog({
    required this.folderMode,
    required this.folderActionHandler,
    super.key,
  });

  @override
  ConsumerState<FolderDialog> createState() => _FolderDialogState();
}

class _FolderDialogState extends ConsumerState<FolderDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.folderMode == FolderMode.add
                  ? 'Add Folder'
                  : 'Edit Folder',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              maxLength: 25,
              controller: _nameController,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      Navigator.pop(context);
                      widget.folderActionHandler(_nameController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(
                      widget.folderMode == FolderMode.add ? 'Add' : 'Edit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
