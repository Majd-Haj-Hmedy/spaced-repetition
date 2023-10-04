import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:repet/providers/folders_provider.dart';
import 'package:repet/widgets/folders/folder_dialog.dart';
import 'package:repet/widgets/folders/folder_item.dart';
import 'package:showcaseview/showcaseview.dart';
import '../models/folder.dart';

enum FolderMode { add, edit }

class FoldersScreen extends ConsumerStatefulWidget {
  final bool firstLaunch;
  const FoldersScreen({required this.firstLaunch, super.key});

  @override
  ConsumerState<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends ConsumerState<FoldersScreen> {
  final _onboardKey = GlobalKey();

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
    final folders = ref.watch(foldersProvider);
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    return WillPopScope(
      onWillPop: () async {
        if (widget.firstLaunch) {
          return false;
        }
        return true;
      },
      child: Stack(
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
              firstLaunch: widget.firstLaunch,
            ),
          ),
          Positioned(
            bottom: 25,
            right: isRTL ? null : 25,
            left: isRTL ? 25 : null,
            child: Showcase(
              key: _onboardKey,
              description: 'showcase_create_folder'.i18n(),
              onTargetClick: () => _showAddFolderDialog(FolderMode.add),
              disposeOnTap: true,
              targetBorderRadius: BorderRadius.circular(16),
              child: FloatingActionButton(
                onPressed: () => _showAddFolderDialog(FolderMode.add),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
