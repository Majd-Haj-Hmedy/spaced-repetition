import 'package:flutter/material.dart';
import 'package:repet/screens/calendar.dart';
import 'package:repet/screens/folders.dart';
import 'package:repet/screens/home.dart';
import 'package:repet/screens/report.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const Map<String, String> _appBarTitleOptions = {
    'home': 'Home',
    'folder': 'Select folder',
    'lecture': 'Lecture details',
    'calendar': 'Calendar',
    'report': 'Report',
  };
  static const List<String> _tabNames = [
    'Home',
    'Lectures',
    'Calendar',
    'Report'
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
        key = 'calendar';
        break;
      case 3:
        key = 'report';
        break;
    }
    _updateAppBarTitle(key);
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = const HomeScreen();
    switch (_navIndex) {
      case 0:
        activeScreen = const HomeScreen();
        break;
      case 1:
        activeScreen = const FoldersScreen();
        break;
      case 2:
        activeScreen = const CalendarScreen();
        break;
      case 3:
        activeScreen = const ReportScreen();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // This line allows more then three items in the navbar
        type: BottomNavigationBarType.fixed,
        currentIndex: _navIndex,
        onTap: _updateScreen,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: _tabNames[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.import_contacts),
            label: _tabNames[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: _tabNames[2],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.equalizer),
            label: _tabNames[3],
          ),
        ],
      ),
      body: activeScreen,
    );
  }
}
