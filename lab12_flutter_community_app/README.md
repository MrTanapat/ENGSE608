# 🏘️ Community Problem Reporter

แอปพลิเคชันสำหรับ**รายงานและติดตามปัญหาในชุมชน** เช่น ถนนเสีย ไฟฟ้าขัดข้อง น้ำประปารั่ว พัฒนาด้วย Flutter + Provider + SQLite

## ✨ คุณสมบัติ (Features)

* **CRUD**: เพิ่ม, ดู, แก้ไข, ลบปัญหา
* **หมวดหมู่**: 8 หมวด (ถนน, ไฟฟ้า, น้ำ, ขยะ, สวน, ความปลอดภัย, เสียง, อื่นๆ)
* **สถานะ**: 3 สถานะ (รอดำเนินการ, กำลังแก้ไข, เสร็จสิ้น)
* **ค้นหา**: ค้นหาจากหัวข้อ, รายละเอียด, สถานที่
* **กรอง**: กรองตามหมวดหมู่และสถานะ
* **สถิติ**: กราฟและสรุปภาพรวม Real-time

### 🎨 หมวดหมู่และสถานะ
**หมวดหมู่:**
🛣️ ถนน | 💡 ไฟฟ้า | 💧 น้ำประปา | 🗑️ ขยะ | 🌳 สวน | 🚨 ปลอดภัย | 🔊 เสียง | 📋 อื่นๆ

**สถานะ:**
🟠 รอดำเนินการ | 🔵 กำลังแก้ไข | 🟢 เสร็จสิ้น

---

## 🛠️ เทคโนโลยีที่ใช้ (Tech Stack)

* **Flutter**: Framework หลักในการพัฒนา
* **Provider**: การจัดการสถานะ (State Management) แบบมีประสิทธิภาพ
* **HTTP**: สำหรับเรียกใช้งาน REST API จากภายนอก
* **Database**: sqflite 2.3.0

## 📁 โครงสร้างโปรเจ็กต์ (Project Structure)

```text
lib/
├── main.dart                          # Entry Point
├── models/
│   └── problem.dart                   # Problem Model
├── database/
│   └── database_helper.dart           # SQLite Helper
├── providers/
│   └── problem_provider.dart          # State Management
└── screens/
    ├── home_screen.dart               # หน้าหลัก
    ├── add_problem_screen.dart        # เพิ่มปัญหา
    ├── problem_detail_screen.dart     # รายละเอียด
    └── statistics_screen.dart         # สถิติ
```

## 🚀 วิธีการติดตั้ง (Installation)

1.  **Clone โปรเจ็กต์**:
    ```bash
    git clone <your-repository-url>
    cd lab12_flutter_community_app
    ```

2.  **ติดตั้ง Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **รันแอปพลิเคชัน**:
    ```bash
    # รันบน Emulator/Mobile
    flutter run

    # หรือรันบน Chrome
    flutter run -d chrome
    ```

## ขั้นตอนการทดสอบ
| หน้าแรก(Current) | พยากรล่วงหน้า 10 วัน | ค้นหาสภาพอากาศ | ปรับสีพื้นหลังตามสภาพอากาศ |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/ce418a37-ace4-4a96-bbb6-81aeccd3037d" width="200" /> | <img src="https://github.com/user-attachments/assets/f6206d69-4db8-4bd4-b1f9-d6b7f4710e38" width="200" /> | <img src="https://github.com/user-attachments/assets/acabf19e-ad7e-4d6c-b4ef-5392bd1c24bb" width="200" /> | <img src="https://github.com/user-attachments/assets/1bdfe2a6-86bf-47dd-9fa7-fd9dfe3bd8d8" width="200" /> |


---
