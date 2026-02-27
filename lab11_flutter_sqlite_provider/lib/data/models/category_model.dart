class Category {
  final int? id;
  final String name; // ชื่อประเภท เช่น ประชุม, งานเอกสาร
  final String colorHex; // เก็บค่าสีเป็น Hex String เช่น #FF5733
  final String iconKey; // เก็บชื่อไอคอนหรือ Codepoint เป็น String

  Category({
    this.id,
    required this.name,
    required this.colorHex,
    required this.iconKey,
  });

  // แปลงจาก Map (ที่ดึงมาจาก SQLite) ให้เป็น Object ของ Category
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      colorHex: map['color_hex'] as String,
      iconKey: map['icon_key'] as String,
    );
  }

  // แปลงจาก Object ของ Category ให้เป็น Map เพื่อนำไปบันทึกลง SQLite
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'color_hex': colorHex, 'icon_key': iconKey};
  }

  // Helper method สำหรับช่วยในการ Copy object (เผื่อใช้ในการอัปเดตข้อมูล)
  Category copyWith({
    int? id,
    String? name,
    String? colorHex,
    String? iconKey,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      iconKey: iconKey ?? this.iconKey,
    );
  }
}
