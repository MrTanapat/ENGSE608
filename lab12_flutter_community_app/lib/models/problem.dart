class Problem {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String location;
  final String status; // pending, in_progress, resolved
  final DateTime createdAt;
  final DateTime? updatedAt;

  Problem({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.status = 'pending',
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Problem to Map (สำหรับบันทึกลง database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // สร้าง Problem จาก Map (สำหรับอ่านจาก database)
  factory Problem.fromMap(Map<String, dynamic> map) {
    return Problem(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      location: map['location'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  // สร้าง copy พร้อมอัพเดทข้อมูล
  Problem copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? location,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Problem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // แปลง status เป็นภาษาไทย
  String get statusText {
    switch (status) {
      case 'pending':
        return 'รอดำเนินการ';
      case 'in_progress':
        return 'กำลังแก้ไข';
      case 'resolved':
        return 'เสร็จสิ้น';
      default:
        return 'ไม่ทราบสถานะ';
    }
  }

  // สีของ status
  String get statusColor {
    switch (status) {
      case 'pending':
        return 'orange';
      case 'in_progress':
        return 'blue';
      case 'resolved':
        return 'green';
      default:
        return 'grey';
    }
  }
}

// หมวดหมู่ปัญหา
class ProblemCategory {
  static const List<String> categories = [
    'ถนน',
    'ไฟฟ้า',
    'น้ำประปา',
    'ขยะ',
    'สวนสาธารณะ',
    'ความปลอดภัย',
    'เสียงรบกวน',
    'อื่นๆ',
  ];

  static String getIcon(String category) {
    switch (category) {
      case 'ถนน':
        return '🛣️';
      case 'ไฟฟ้า':
        return '💡';
      case 'น้ำประปา':
        return '💧';
      case 'ขยะ':
        return '🗑️';
      case 'สวนสาธารณะ':
        return '🌳';
      case 'ความปลอดภัย':
        return '🚨';
      case 'เสียงรบกวน':
        return '🔊';
      default:
        return '📋';
    }
  }
}
