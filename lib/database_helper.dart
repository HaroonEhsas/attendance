import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'attendance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE leaves (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER,
            start_date TEXT,
            end_date TEXT,
            reason TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  // Method to get leaves
  Future<List<Map<String, dynamic>>> getLeaves() async {
    final db = await database;
    return await db.query('leaves');
  }

  // Method to apply for leave
  Future<int> applyLeave(Map<String, dynamic> leaveData) async {
    final db = await database;
    return await db.insert('leaves', leaveData);
  }
}
