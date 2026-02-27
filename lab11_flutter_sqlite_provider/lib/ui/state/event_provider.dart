import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/db/database_helper.dart';

class EventProvider with ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> get events => _events;

  // ตัวแปรเก็บสถานะการกรองปัจจุบัน
  String _currentFilter = 'all';
  String get currentFilter => _currentFilter;

  // ฟังก์ชันสำหรับเปลี่ยน Filter จากหน้า UI
  Future<void> setFilter(String filter) async {
    _currentFilter = filter;
    await fetchEvents();
  }

  Future<void> fetchEvents() async {
    final db = await DatabaseHelper.instance.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    // 1. Logic การกรองข้อมูล (Filter Logic)
    if (_currentFilter == 'today') {
      whereClause = 'WHERE events.event_date = ?';
      whereArgs = [DateFormat('yyyy-MM-dd').format(DateTime.now())];
    } else if (_currentFilter != 'all') {
      whereClause = 'WHERE events.status = ?';
      whereArgs = [_currentFilter];
    }

    // 2. ดึงข้อมูลพร้อม Join กับตาราง Categories เพื่อเอาชื่อหมวดหมู่และสีมาใช้
    _events = await db.rawQuery('''
      SELECT events.*, categories.name as cat_name, categories.color_hex
      FROM events
      INNER JOIN categories ON events.category_id = categories.id
      $whereClause
      ORDER BY event_date ASC, start_time ASC
    ''', whereArgs);

    // 3. เพิ่มส่วนการ Print เพื่อเช็คข้อมูลใน Debug Console (ตามที่คุณต้องการ)
    print("--- ข้อมูลในฐานข้อมูล (Filter: $_currentFilter) ---");
    if (_events.isEmpty) {
      print("ไม่พบข้อมูลกิจกรรม");
    } else {
      for (var row in _events) {
        print(
          "Event: ${row['title']} | Status: ${row['status']} | Reminder: ${row['reminder_minutes']} min | Date: ${row['event_date']}",
        );
      }
    }
    print("--------------------------------------------------");

    notifyListeners();
  }

  Future<String?> addEvent(Map<String, dynamic> data) async {
    // ตรวจสอบเงื่อนไขเวลา: End Time > Start Time
    if (data['end_time'].compareTo(data['start_time']) <= 0) {
      return "เวลาเลิกงานต้องอยู่หลังเวลาเริ่มงาน";
    }

    final db = await DatabaseHelper.instance.database;

    if (data['id'] == null) {
      // เพิ่มใหม่
      await db.insert('events', data);
    } else {
      // แก้ไข
      await db.update('events', data, where: 'id = ?', whereArgs: [data['id']]);
    }

    await fetchEvents();
    return null; // สำเร็จ
  }
}
