import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:repet/models/folder.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/providers/lectures_provider.dart';
import 'package:repet/screens/folders.dart';
import 'package:repet/screens/lectures.dart';
import 'package:repet/widgets/folders/folder_dialog.dart';
import 'package:showcaseview/showcaseview.dart';

// ignore: must_be_immutable
class FolderItem extends ConsumerStatefulWidget {
  final Folder folder;
  final bool firstLaunch;
  const FolderItem({
    required this.folder,
    required this.firstLaunch,
    super.key,
  });

  @override
  ConsumerState<FolderItem> createState() => _FolderItemState();
}

class _FolderItemState extends ConsumerState<FolderItem> {
  final _onboardKey = GlobalKey();

  void _deleteFolder() {
    ref.read(foldersProvider.notifier).removeFolder(widget.folder);
  }

  void _renameFolder(Folder folder, String name) {
    ref.read(foldersProvider.notifier).renameFolder(folder, name);
  }

  void _showRenameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FolderDialog(
          folderMode: FolderMode.edit,
          editedFolderName: widget.folder.name,
          folderActionHandler: (name) => _renameFolder(widget.folder, name),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('folders_delete_dialog_title'.i18n()),
        content: Text(
            'folders_delete_dialog_content'.i18n()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('folders_delete_dialog_cancel'.i18n()),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteFolder();
              final lecturesList = ref
                  .read(lecturesProvider.notifier)
                  .fetchLecturesByFolder(widget.folder);

              for (final lecture in lecturesList) {
                ref.read(lecturesProvider.notifier).deleteLecture(lecture);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('folders_delete_dialog_delete'.i18n()),
          ),
        ],
      ),
    );
  }

  void _openLecturesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LecturesScreen(
          folder: widget.folder,
          firstLaunch: widget.firstLaunch,
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.firstLaunch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_onboardKey]);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openLecturesScreen,
      child: Showcase(
        key: _onboardKey,
        description: 'showcase_open_folder'.i18n(),
        onTargetClick: _openLecturesScreen,
        disposeOnTap: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Icon(
                Icons.folder,
                color: Theme.of(context).colorScheme.primary,
                size: 100,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Container(
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: Text(
                    widget.folder.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                PopupMenuButton(
                  onSelected: (value) => value == 0
                      ? _showRenameDialog(context)
                      : _showDeleteDialog(context),
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text('folders_rename'.i18n()),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text('folders_delete'.i18n()),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
