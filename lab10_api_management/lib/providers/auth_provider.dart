import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      // 1. เรียก API จริง
      final result = await _apiService.login(username, password);

      _isLoading = false;
      if (result != null) {
        // --- ส่วนที่เพิ่มเข้ามาตามโจทย์ ---
        // ตรวจสอบว่าถ้าเป็น 'johnd' ให้บังคับเป็น ID 1 (Admin)
        // คนอื่นที่ล็อกอินผ่านให้เป็น ID อื่น (User ทั่วไป)
        if (username == 'johnd') {
          _user = User(
            id: 1, // กำหนด ID=1 ให้เป็น Admin ตามโจทย์
            username: result.username,
            email: result.email,
            token: result.token,
          );
        } else {
          _user = result; // ID จาก API ทั่วไปที่ไม่ใช่ 1
        }
        // ------------------------------

        notifyListeners();
        return true;
      } else {
        // ล็อกอินไม่สำเร็จ (รหัสผิด)
        _user = null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _user = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
