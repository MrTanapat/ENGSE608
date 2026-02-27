import '../db/database_helper.dart';
import '../models/event_model.dart';

class EventRepository {
  final dbHelper = DatabaseHelper.instance;

  // 1. เพิ่มกิจกรรมใหม่
  Future<int> insertEvent(Event event) async {
    final db = await dbHelper.database;
    return await db.insert('events', event.toMap());
  }

  // 2. ดึงข้อมูลกิจกรรมทั้งหมด พร้อมข้อมูลหมวดหมู่ (Join Table)
  // โจทย์ข้อ 3.2: ต้องดึงข้อมูลที่เชื่อมกับ Category มาแสดงได้
  Future<List<Map<String, dynamic>>> getAllEventsWithCategory() async {
    final db = await dbHelper.database;
    return await db.rawQuery('''
      SELECT e.*, c.name as category_name, c.color_hex, c.icon_key
      FROM events e
      INNER JOIN categories c ON e.category_id = c.id
      ORDER BY e.event_date DESC, e.start_time DESC
    ''');
  }

  // 3. ค้นหาและกรองกิจกรรม (โจทย์ข้อ 3.4)
  // รองรับการค้นหาจากชื่อ, กรองตามสถานะ, หรือกรองตามหมวดหมู่
  Future<List<Map<String, dynamic>>> getFilteredEvents({
    String? searchQuery,
    String? status,
    int? categoryId,
  }) async {
    final db = await dbHelper.database;
    String sql = '''
      SELECT e.*, c.name as category_name, c.color_hex, c.icon_key
      FROM events e
      INNER JOIN categories c ON e.category_id = c.id
      WHERE 1=1
    ''';
    List<dynamic> args = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      sql += " AND e.title LIKE ?";
      args.add('%$searchQuery%');
    }
    if (status != null && status != 'All') {
      sql += " AND e.status = ?";
      args.add(status);
    }
    if (categoryId != null) {
      sql += " AND e.category_id = ?";
      args.add(categoryId);
    }

    sql += " ORDER BY e.event_date ASC, e.start_time ASC";
    return await db.rawQuery(sql, args);
  }

  // 4. อัปเดตข้อมูลกิจกรรม (โจทย์ข้อ 3.2 และ 3.3)
  Future<int> updateEvent(Event event) async {
    final db = await dbHelper.database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // 5. เปลี่ยนสถานะกิจกรรม (โจทย์ข้อ 3.3: เปลี่ยนเป็น Completed/Cancelled)
  Future<int> updateEventStatus(int id, String newStatus) async {
    final db = await dbHelper.database;
    return await db.update(
      'events',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 6. ลบกิจกรรม
  Future<int> deleteEvent(int id) async {
    final db = await dbHelper.database;
    return await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}
