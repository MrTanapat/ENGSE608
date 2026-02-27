class Reminder {
  final int? id;
  final int eventId; // Foreign Key เชื่อมกับตาราง events
  final int minutesBefore; // แจ้งเตือนล่วงหน้ากี่นาที (เช่น 5, 15, 30, 60)
  final bool isEnabled; // สถานะ เปิด/ปิด การแจ้งเตือน

  Reminder({
    this.id,
    required this.eventId,
    required this.minutesBefore,
    this.isEnabled = true,
  });

  // แปลงจาก Map (SQLite) เป็น Object
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      eventId: map['event_id'] as int,
      minutesBefore: map['minutes_before'] as int,
      // SQLite เก็บ boolean เป็น 0 หรือ 1
      isEnabled: map['is_enabled'] == 1,
    );
  }

  // แปลงจาก Object เป็น Map เพื่อลง DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'minutes_before': minutesBefore,
      'is_enabled': isEnabled ? 1 : 0,
    };
  }

  // ใช้สำหรับสร้าง Object ใหม่เมื่อมีการแก้ไขข้อมูลบางส่วน
  Reminder copyWith({
    int? id,
    int? eventId,
    int? minutesBefore,
    bool? isEnabled,
  }) {
    return Reminder(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      minutesBefore: minutesBefore ?? this.minutesBefore,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
