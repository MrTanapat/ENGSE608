import '../db/database_helper.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final dbHelper = DatabaseHelper.instance;

  // 1. เพิ่มประเภทกิจกรรม
  Future<int> insertCategory(Category category) async {
    final db = await dbHelper.database;
    return await db.insert('categories', category.toMap());
  }

  // 2. ดึงข้อมูลประเภทกิจกรรมทั้งหมด
  Future<List<Category>> getAllCategories() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  // 3. แก้ไขประเภทกิจกรรม
  Future<int> updateCategory(Category category) async {
    final db = await dbHelper.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // 4. ลบประเภทกิจกรรม (พร้อมเงื่อนไขตรวจสอบการใช้งาน)
  Future<String?> deleteCategory(int id) async {
    final db = await dbHelper.database;

    // ตรวจสอบว่ามี Event ไหนใช้ Category นี้อยู่หรือไม่ (ตามโจทย์ 3.1)
    final List<Map<String, dynamic>> result = await db.query(
      'events',
      where: 'category_id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return "ไม่สามารถลบได้: มีกิจกรรมที่ใช้งานหมวดหมู่นี้อยู่";
    }

    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    return null; // ลบสำเร็จ
  }
}
