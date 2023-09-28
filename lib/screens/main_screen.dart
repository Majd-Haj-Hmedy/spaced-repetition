import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:repet/screens/folders.dart';
import 'package:repet/screens/home.dart';
import 'package:repet/screens/report.dart';
import 'package:ionicons/ionicons.dart';
import 'package:repet/widgets/drawer/main_drawer.dart';
import 'package:showcaseview/showcaseview.dart';

class MainScreen extends ConsumerStatefulWidget {
  final bool firstLaunch;
  const MainScreen({
    required this.firstLaunch,
    super.key,
  });

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final _onboardKey = GlobalKey();

  static final Map<String, String> _appBarTitleOptions = {
    'home': 'home_appbar'.i18n(),
    'folder': 'Select folder',
    'report': 'Reports',
  };
  static const List<String> _tabNames = [
    'Home',
    'Lectures',
    'Reports',
  ];
  var _navIndex = 0;
  var _appBarTitle = 'Home';

  void _updateAppBarTitle(String key) {
    setState(() {
      _appBarTitle = _appBarTitleOptions[key]!;
    });
  }

  void _updateScreen(int index) {
    setState(() {
      _navIndex = index;
    });

    var key = '';
    switch (_navIndex) {
      case 0:
        key = 'home';
        break;
      case 1:
        key = 'folder';
        break;
      case 2:
        key = 'report';
        break;
    }
    _updateAppBarTitle(key);
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
    Widget activeScreen = const HomeScreen();
    switch (_navIndex) {
      case 0:
        activeScreen = const HomeScreen();
        break;
      case 1:
        activeScreen = FoldersScreen(firstLaunch: widget.firstLaunch);
        break;
      case 2:
        activeScreen = const ReportScreen();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: _updateScreen,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_sharp),
            label: _tabNames[0],
          ),
          Showcase(
            key: _onboardKey,
            description: 'Go to the lectures ',
            onTargetClick: () => _updateScreen(1),
            disposeOnTap: true,
            child: NavigationDestination(
              icon: const Icon(Ionicons.book_outline),
              selectedIcon: const Icon(Ionicons.book),
              label: _tabNames[1],
            ),
          ),
          NavigationDestination(
            icon: const Icon(Ionicons.analytics_outline),
            selectedIcon: const Icon(Ionicons.analytics),
            label: _tabNames[2],
          ),
        ],
      ),
      body: activeScreen,
    );
  }
}
