import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('event_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2, // *** ปรับเป็นเวอร์ชัน 2 ***
      onCreate: _createDB,
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade, // เพิ่มส่วนการอัปเกรด
    );
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // ฟังก์ชันอัปเกรดตารางสำหรับเครื่องที่เคยรันเวอร์ชัน 1 ไปแล้ว
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE events ADD COLUMN reminder_minutes INTEGER DEFAULT 15',
      );
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      color_hex TEXT NOT NULL,
      icon_key TEXT NOT NULL
    )''');

    await db.execute('''CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      category_id INTEGER,
      event_date TEXT NOT NULL,
      start_time TEXT NOT NULL,
      end_time TEXT NOT NULL,
      status TEXT DEFAULT 'pending',
      priority INTEGER DEFAULT 2,
      reminder_minutes INTEGER DEFAULT 15, -- *** เพิ่มคอลัมน์นี้เข้าไป ***
      FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE RESTRICT
    )''');

    await db.execute('''CREATE TABLE reminders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      event_id INTEGER,
      minutes_before INTEGER,
      is_enabled INTEGER DEFAULT 1,
      FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE
    )''');
  }
}
