import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:repet/screens/folders.dart';

class FolderDialog extends ConsumerStatefulWidget {
  final FolderMode folderMode;
  final String? editedFolderName;
  final void Function(String name) folderActionHandler;
  const FolderDialog({
    required this.folderMode,
    this.editedFolderName,
    required this.folderActionHandler,
    super.key,
  });

  @override
  ConsumerState<FolderDialog> createState() => _FolderDialogState();
}

class _FolderDialogState extends ConsumerState<FolderDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.editedFolderName ?? '');
    super.initState();
  }

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
                  ? 'folders_add_dialog_title'.i18n()
                  : 'folders_edit_dialog_title'.i18n(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              maxLength: 25,
              controller: _nameController,
              decoration: InputDecoration(
                label: Text('folders_add_dialog_name_hint'.i18n()),
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
                  child: Text('folders_add_dialog_cancel'.i18n()),
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
                    widget.folderMode == FolderMode.add
                        ? 'folders_add_dialog_add'.i18n()
                        : 'folders_edit_dialog_add'.i18n(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
