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
| หน้าแรก | รายละเอียดปัญหา | สถิติรายงานปัญหา | ปรับสีพื้นหลังตามสภาพอากาศ | ปรับสีพื้นหลังตามสภาพอากาศ |
| :---: | :---: | :---: | :---: | :---: |
| <img width="200" src="https://github.com/user-attachments/assets/056f5c0d-2424-49d9-894d-7f33e1ae0e33" />| <img width="200" src="https://github.com/user-attachments/assets/1b559784-c3da-4ae8-857a-5b9c180ed756" />| <img width="200" src="https://github.com/user-attachments/assets/3bbe28e1-4c31-4c76-aecd-029f0fd53566" />| <img width="200" src="https://github.com/user-attachments/assets/23817790-0511-443b-8b13-a03c8c07eb9b" />| <img width="200" src="https://github.com/user-attachments/assets/563756e9-8a72-4908-9b26-acad45d48104" />



---
