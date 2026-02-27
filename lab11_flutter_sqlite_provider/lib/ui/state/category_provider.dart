import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

class CategoryProvider with ChangeNotifier {
  // สร้าง Instance ของ Repository เพื่อติดต่อกับฐานข้อมูล
  final CategoryRepository _repository = CategoryRepository();

  // เก็บรายการหมวดหมู่ทั้งหมดไว้ในตัวแปรนี้
  List<Category> _categories = [];

  // Getter สำหรับให้ UI เรียกใช้ (แต่อ่านได้อย่างเดียว)
  List<Category> get categories => _categories;

  // 1. ดึงข้อมูลหมวดหมู่ทั้งหมดจาก DB
  Future<void> fetchCategories() async {
    _categories = await _repository.getAllCategories();
    notifyListeners(); // แจ้งเตือน UI ให้ Update
  }

  // 2. เพิ่มหมวดหมู่ใหม่
  Future<void> addCategory(Category category) async {
    await _repository.insertCategory(category);
    await fetchCategories(); // โหลดข้อมูลใหม่หลังจากเพิ่มเสร็จ
  }

  // 3. แก้ไขหมวดหมู่
  Future<void> editCategory(Category category) async {
    await _repository.updateCategory(category);
    await fetchCategories();
  }

  // 4. ลบหมวดหมู่ (พร้อมส่งคืน Error Message ถ้าลบไม่ได้)
  Future<String?> removeCategory(int id) async {
    // เรียกใช้ Logic ตรวจสอบการใช้งานก่อนลบที่เขียนไว้ใน Repository
    final error = await _repository.deleteCategory(id);

    if (error == null) {
      // ถ้า error เป็น null แสดงว่าลบสำเร็จ
      await fetchCategories();
    }
    return error; // ส่งข้อความ error กลับไปให้ UI แสดงผล (ถ้ามี)
  }
}
