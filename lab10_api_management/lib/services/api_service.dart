import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = "https://fakestoreapi.com";

  Future<User?> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      debugPrint('Login Status: ${response.statusCode}');
      debugPrint('Login Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // FakeStoreAPI ส่งกลับมาแค่ { "token": "..." }
        // เราจะจำลองข้อมูล User ตามโจทย์ที่ต้องการเช็ค ID
        return User(
          id: username == 'johnd' ? 1 : 2,
          username: username,
          email: "$username@example.com",
          token: data['token'],
        );
      }
      return null;
    } catch (e) {
      debugPrint('Login Error: $e');
      return null;
    }
  }

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
