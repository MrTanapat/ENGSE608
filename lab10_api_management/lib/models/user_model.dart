class User {
  final int id;
  final String username;
  final String email;
  final String? token; // สำหรับเก็บค่าหลัง Login สำเร็จ

  User({required this.id, required this.username, required this.email, this.token});

  // แปลงจาก JSON (API) มาเป็น Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  // Getter เช็คว่าเป็น Admin หรือไม่ (ID = 1 ตามโจทย์)
  bool get isAdmin => id == 1;
}
