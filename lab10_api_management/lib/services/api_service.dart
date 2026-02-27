import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = "https://fakestoreapi.com"\;

  // 1. ระบบ Login
  Future<User?> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // หมายเหตุ: FakeStoreAPI คืนค่าแค่ token 
        // ในแล็บนี้เราจะจำลองข้อมูล User กลับไปด้วย (เช่น id: 1 สำหรับแอดมิน)
        // เพื่อให้ตรงตามโจทย์ที่ต้องเช็ค ID
        return User(
          id: username == 'johnd' ? 1 : 2, // สมมติให้ johnd เป็นแอดมิน (ID=1)
          username: username,
          email: "$username@example.com",
          token: data['token'],
        );
      }
      return null;
    } catch (e) {
      throw Exception("Error during login: $e");
    }
  }

  // 2. ดึงรายการสินค้าทั้งหมด
  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse("$baseUrl/products");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  // 3. ดึงรายชื่อ User ทั้งหมด (สำหรับ Admin)
  Future<List<User>> fetchAllUsers() async {
    final url = Uri.parse("$baseUrl/users");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }
}
