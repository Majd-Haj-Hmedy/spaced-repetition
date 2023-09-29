import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'repet.db'),
      version: 1,
      onCreate: _createDatabase,
    );
    return db;
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE FOLDERS (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE LECTURES (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        difficulty INTEGER,
        folder_id INTEGER,
        current_stage INTEGER,
        current_date INTEGER,
        date1 TEXT NOT NULL,
        date2 TEXT NOT NULL,
        date3 TEXT NOT NULL,
        date4 TEXT NOT NULL,
        date5 TEXT NOT NULL,
        history1 TEXT,
        history2 TEXT,
        history3 TEXT,
        history4 TEXT,
        history5 TEXT,
        FOREIGN KEY (folder_id) REFERENCES folders (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE COMPLETIONS (
        status INTEGER,
        date TEXT,
        folder_name TEXT
      )
    ''');
  }
}
