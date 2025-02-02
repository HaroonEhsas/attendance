import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geolocator/geolocator.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'attendance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendance(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER,
        check_in TEXT,
        check_out TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE teams(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE team_members(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        team_id INTEGER,
        employee_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        assigned_to INTEGER,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender_id INTEGER,
        message TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<void> insertAttendance(Map<String, dynamic> attendance) async {
    final db = await database;
    await db.insert('attendance', attendance);
  }

  Future<List<Map<String, dynamic>>> getAttendance() async {
    final db = await database;
    return await db.query('attendance');
  }

  Future<void> createTeam(String name) async {
    final db = await database;
    await db.insert('teams', {'name': name});
  }

  Future<List<Map<String, dynamic>>> getTeams() async {
    final db = await database;
    return await db.query('teams');
  }

  Future<void> assignEmployeeToTeam(int employeeId, int teamId) async {
    final db = await database;
    await db.insert('team_members', {
      'team_id': teamId,
      'employee_id': employeeId,
    });
  }

  Future<void> createTask(Map<String, dynamic> task) async {
    final db = await database;
    await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<void> sendMessage(Map<String, dynamic> message) async {
    final db = await database;
    await db.insert('messages', message);
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await database;
    return await db.query('messages');
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}