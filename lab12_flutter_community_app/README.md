# 🏘️ Community Care: ระบบแจ้งปัญหาเพื่อพัฒนาชุมชน
 
แอปพลิเคชันสำหรับ**รายงานและติดตามปัญหาในชุมชน** เช่น ถนนเสีย ไฟฟ้าขัดข้อง น้ำประปารั่ว พัฒนาด้วย Flutter + Provider + SQLite
 
---
 
## 📖 วัตถุประสงค์ (Objectives)
 
แอปพลิเคชันนี้พัฒนาขึ้นเพื่อ:
- 📝 ให้ชาวชุมชนสามารถรายงานปัญหาในชุมชนได้ง่ายและสะดวก
- 👀 ติดตามสถานะการแก้ไขปัญหาแบบ Real-time
- 📊 วิเคราะห์และแสดงสถิติปัญหาในชุมชน
- 🔍 ค้นหาและจัดการปัญหาได้อย่างมีประสิทธิภาพ
- 🤝 ส่งเสริมการมีส่วนร่วมของชุมชนในการพัฒนาท้องถิ่น
 
---
 
## ✨ คุณสมบัติ (Features)
 
### 🎯 ฟีเจอร์หลัก
 
* **CRUD Operations**: เพิ่ม, ดู, แก้ไข, ลบรายงานปัญหา
* **หมวดหมู่**: 8 หมวดหมู่ (ถนน, ไฟฟ้า, น้ำประปา, ขยะ, สวนสาธารณะ, ความปลอดภัย, เสียงรบกวน, อื่นๆ)
* **สถานะ**: 3 สถานะ (รอดำเนินการ, กำลังแก้ไข, เสร็จสิ้น)
* **ค้นหา**: ค้นหาปัญหาจากหัวข้อ, รายละเอียด, หรือสถานที่
* **กรอง**: กรองรายการตามหมวดหมู่และสถานะ
* **สถิติ**: แสดงกราฟและสรุปภาพรวมแบบ Real-time
* **การแจ้งเตือน**: แสดงสถานะการทำงานผ่าน SnackBar
* **ตรวจสอบข้อมูล**: ตรวจสอบความถูกต้องของข้อมูลก่อนบันทึก
 
### 🎨 หมวดหมู่และสถานะ
 
**หมวดหมู่ปัญหา:**
- 🛣️ ถนน
- 💡 ไฟฟ้า
- 💧 น้ำประปา
- 🗑️ ขยะ
- 🌳 สวนสาธารณะ
- 🚨 ความปลอดภัย
- 🔊 เสียงรบกวน
- 📋 อื่นๆ
 
**สถานะการดำเนินการ:**
- 🟠 รอดำเนินการ (Pending)
- 🔵 กำลังแก้ไข (In Progress)
- 🟢 เสร็จสิ้น (Resolved)
 
---
 
## 🛠️ เทคโนโลยีที่ใช้ (Tech Stack)
 
| เทคโนโลยี | เวอร์ชัน | วัตถุประสงค์ |
|-----------|----------|-------------|
| **Flutter** | 3.0+ | Framework หลักในการพัฒนา UI |
| **Dart** | 3.0+ | ภาษาโปรแกรมมิ่ง |
| **Provider** | 6.1.1 | State Management |
| **sqflite** | 2.3.0 | Local Database (SQLite) |
| **path_provider** | 2.1.1 | จัดการ path ของไฟล์ |
| **intl** | 0.18.1 | จัดรูปแบบวันที่และเวลา |
 
### สถาปัตยกรรม (Architecture)
 
```
┌─────────────────────┐
│   UI Layer          │  Screens (Flutter Widgets)
├─────────────────────┤
│   State Management  │  Provider (ChangeNotifier)
├─────────────────────┤
│   Business Logic    │  Models & Helper Methods
├─────────────────────┤
│   Data Layer        │  SQLite Database
└─────────────────────┘
```
 
---
 
## 📁 โครงสร้างโปรเจ็กต์ (Project Structure)
 
```
lib/
├── main.dart                          # Entry Point
├── models/
│   └── problem.dart                   # Problem Model + Category Class
├── database/
│   └── database_helper.dart           # SQLite Helper (CRUD Operations)
├── providers/
│   └── problem_provider.dart          # State Management (Provider)
└── screens/
    ├── home_screen.dart               # หน้าหลัก (รายการปัญหา)
    ├── add_problem_screen.dart        # หน้าเพิ่มปัญหาใหม่
    ├── problem_detail_screen.dart     # หน้ารายละเอียดปัญหา
    └── statistics_screen.dart         # หน้าสถิติ
```
 
---
 
## 🚀 วิธีการติดตั้ง (Installation)
 
### ข้อกำหนดเบื้องต้น (Prerequisites)
 
- Flutter SDK 3.0 หรือสูงกว่า
- Dart SDK 3.0 หรือสูงกว่า
- Android Studio / VS Code
- Android Emulator หรือ Physical Device
 
### ขั้นตอนการติดตั้ง
 
1. **Clone โปรเจ็กต์**
   ```bash
   git clone <repository-url>
   cd community_problem_reporter
   ```
 
2. **ติดตั้ง Dependencies**
   ```bash
   flutter pub get
   ```
 
3. **รันแอปพลิเคชัน**
   ```bash
   # รันบน Emulator/Physical Device
   flutter run
   
   # รันบน Chrome (Web)
   flutter run -d chrome
   
   # รันแบบ Release Mode
   flutter run --release
   ```
 
4. **Build APK (สำหรับ Android)**
   ```bash
   flutter build apk --release
   
   # ไฟล์จะอยู่ที่:
   # build/app/outputs/flutter-apk/app-release.apk
   ```
 
---
 
## 💻 วิธีการใช้งาน (How to Use)
 
### 1. เพิ่มรายงานปัญหา
1. กดปุ่ม **"+ รายงานปัญหา"** ที่มุมล่างขวา
2. กรอกข้อมูล:
   - หัวข้อปัญหา
   - เลือกหมวดหมู่
   - ระบุสถานที่
   - เขียนรายละเอียด
3. กดปุ่ม **"ส่งรายงาน"**
 
### 2. ค้นหาปัญหา
- พิมพ์คำค้นหาในช่อง Search ที่หน้าหลัก
- ระบบจะค้นหาจาก: หัวข้อ, รายละเอียด, สถานที่
 
### 3. กรองรายการ
1. กดปุ่ม **Filter** (ไอคอนกรอง)
2. เลือกหมวดหมู่หรือสถานะที่ต้องการ
3. กด **"ปิด"**
 
### 4. ดูรายละเอียดและจัดการปัญหา
1. กดที่ Card ของปัญหาที่ต้องการ
2. ดูข้อมูลครบถ้วน
3. สามารถ:
   - เปลี่ยนสถานะ (รอดำเนินการ → กำลังแก้ไข → เสร็จสิ้น)
   - ลบรายงาน (กดไอคอนถังขยะ)
 
### 5. ดูสถิติ
- กดปุ่ม **📊** ที่มุมขวาบน
- ดูสรุปภาพรวมและกราฟ
 
---
 
## 📸 ภาพตัวอย่างการใช้งาน (Screenshots)
| หน้าแรก | เพิ่มรายงานปัญหา | รายละเอียดปัญหา | สถิติรายงานปัญหา | การ Fillter |
| :---: | :---: | :---: | :---: | :---: |
| <img width="200" src="https://github.com/user-attachments/assets/056f5c0d-2424-49d9-894d-7f33e1ae0e33" />| <img width="200" src="https://github.com/user-attachments/assets/1b559784-c3da-4ae8-857a-5b9c180ed756" />| <img width="200" src="https://github.com/user-attachments/assets/3bbe28e1-4c31-4c76-aecd-029f0fd53566" />| <img width="200" src="https://github.com/user-attachments/assets/23817790-0511-443b-8b13-a03c8c07eb9b" />| <img width="200" src="https://github.com/user-attachments/assets/563756e9-8a72-4908-9b26-acad45d48104" />

## 🧪 การทดสอบ (Testing)
 
### Test Cases
 
| ID | Feature | Description | Status |
|----|---------|-------------|--------|
| TC001 | เปิด App | แสดงหน้าหลัก Empty State | ✅ Pass |
| TC002 | เพิ่มปัญหา | บันทึกข้อมูลลง Database | ✅ Pass |
| TC003 | Validation | ตรวจสอบข้อมูลก่อนบันทึก | ✅ Pass |
| TC004 | แสดงรายการ | แสดงปัญหาทั้งหมด | ✅ Pass |
| TC005 | ค้นหา | ค้นหาแบบ Real-time | ✅ Pass |
| TC006 | กรอง | กรองตามหมวดหมู่/สถานะ | ✅ Pass |
| TC007 | รายละเอียด | แสดงข้อมูลครบถ้วน | ✅ Pass |
| TC008 | เปลี่ยนสถานะ | อัพเดทสถานะปัญหา | ✅ Pass |
| TC009 | ลบ | ลบรายงานพร้อม Confirmation | ✅ Pass |
| TC010 | สถิติ | แสดงกราฟและสรุป | ✅ Pass |
| TC011 | Pull Refresh | รีเฟรชข้อมูล | ✅ Pass |
| TC012 | Multi-Filter | ใช้หลายตัวกรองพร้อมกัน | ✅ Pass |
 
**ผลการทดสอบ:** 12/12 Pass (100%)
 
---
 
## 📱 การสร้างไฟล์ติดตั้ง (Build Release)
 
### Android (.apk)
 
```bash
# Build APK
flutter build apk --release
 
# ไฟล์จะอยู่ที่:
# build/app/outputs/flutter-apk/app-release.apk
```
 
### iOS (.ipa) - macOS Only
 
```bash
flutter build ios --release
```
 
### Web
 
```bash
flutter build web --release
 
# ไฟล์จะอยู่ที่:
# build/web/
```
 
---
 
## 🗄️ Database Schema
 
### Table: problems
 
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary Key (Auto Increment) |
| title | TEXT | หัวข้อปัญหา |
| description | TEXT | รายละเอียด |
| category | TEXT | หมวดหมู่ |
| location | TEXT | สถานที่ |
| status | TEXT | สถานะ (pending/in_progress/resolved) |
| createdAt | TEXT | วันที่สร้าง (ISO8601) |
| updatedAt | TEXT | วันที่อัพเดท (ISO8601) |
 
---

## 👨‍💻 ผู้พัฒนา (Developer)
 
**ชื่อ-นามสกุล:** ธนภัทร นุกูล <br>
**รหัสนักศึกษา:** 67543210031-0 <br>
**วิชา:** Mobile Devices Application Design and Development

---
