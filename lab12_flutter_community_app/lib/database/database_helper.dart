import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/problem.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter สำหรับ database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('problems.db');
    return _database!;
  }

  // สร้าง database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // สร้าง table
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE problems (
        id $idType,
        title $textType,
        description $textType,
        category $textType,
        location $textType,
        status $textType,
        createdAt $textType,
        updatedAt TEXT
      )
    ''');
  }

  // เพิ่มปัญหาใหม่
  Future<Problem> create(Problem problem) async {
    final db = await database;
    final id = await db.insert('problems', problem.toMap());
    return problem.copyWith(id: id);
  }

  // อ่านปัญหาทั้งหมด
  Future<List<Problem>> readAllProblems() async {
    final db = await database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('problems', orderBy: orderBy);
    return result.map((json) => Problem.fromMap(json)).toList();
  }

  // อ่านปัญหาตาม ID
  Future<Problem?> readProblem(int id) async {
    final db = await database;
    final maps = await db.query(
      'problems',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Problem.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // อัพเดทปัญหา
  Future<int> update(Problem problem) async {
    final db = await database;
    return db.update(
      'problems',
      problem.toMap(),
      where: 'id = ?',
      whereArgs: [problem.id],
    );
  }

  // ลบปัญหา
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'problems',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ค้นหาปัญหาตาม category
  Future<List<Problem>> readProblemsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'problems',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Problem.fromMap(json)).toList();
  }

  // ค้นหาปัญหาตาม status
  Future<List<Problem>> readProblemsByStatus(String status) async {
    final db = await database;
    final result = await db.query(
      'problems',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Problem.fromMap(json)).toList();
  }

  // นับจำนวนปัญหาตาม status
  Future<Map<String, int>> getStatusCounts() async {
    final db = await database;

    final pendingCount = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM problems WHERE status = ?', ['pending'])) ??
        0;

    final inProgressCount = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM problems WHERE status = ?',
            ['in_progress'])) ??
        0;

    final resolvedCount = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM problems WHERE status = ?', ['resolved'])) ??
        0;

    return {
      'pending': pendingCount,
      'in_progress': inProgressCount,
      'resolved': resolvedCount,
    };
  }

  // นับจำนวนปัญหาตาม category
  Future<Map<String, int>> getCategoryCounts() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT category, COUNT(*) as count FROM problems GROUP BY category');

    Map<String, int> counts = {};
    for (var row in result) {
      counts[row['category'] as String] = row['count'] as int;
    }

    return counts;
  }

  // ค้นหาปัญหาด้วยคำค้น
  Future<List<Problem>> searchProblems(String query) async {
    final db = await database;
    final result = await db.query(
      'problems',
      where: 'title LIKE ? OR description LIKE ? OR location LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Problem.fromMap(json)).toList();
  }

  // ปิด database
  Future close() async {
    final db = await database;
    db.close();
  }
}
