# Event & Reminder App (Offline) – Flutter + SQLite + Provider

## เป้าหมายการเรียนรู้
- ออกแบบตารางฐานข้อมูล SQLite ให้รองรับกิจกรรม/ประเภท/การแจ้งเตือน/สถานะ
- พัฒนา CRUD ด้วย sqflite และจัดการ State ด้วย provider
- สร้างหน้าจอ list/detail/form พร้อมฟังก์ชันกรอง/ค้นหา/จัดเรียง
- จัดการ “สถานะกิจกรรม” และ “ช่วงเวลา” ได้ถูกต้อง

## Tech Stack
- Framework: Flutter
- Database: SQLite (sqflite package)
- State Management: Provider
- Formatting: intl (จัดการ Date/Time Format)

---

## App Features
### 1. ระบบจัดการหมวดหมู่
- [x] **Dynamic Categories:** เพิ่ม แก้ไข และลบหมวดหมู่กิจกรรมได้ไม่จำกัด
- [x] **Color Personalization:** เลือกสีประจำหมวดหมู่เพื่อใช้เป็นสัญลักษณ์ (Color-coded) ช่วยในการจำแนกกิจกรรมในหน้า Dashboard
- [x] **Quick Setup:** ฟีเจอร์ "เพิ่มตัวอย่าง" (Seed Data) ช่วยสร้างหมวดหมู่พื้นฐาน 5 ประเภทอัตโนมัติ เพื่อความรวดเร็วในการเริ่มใช้งาน

### 2. ระบบจัดการกิจกรรม
- [x] **Full CRUD Support:** รองรับการเพิ่ม (Create), เรียกดู (Read), แก้ไข (Update) และลบ (Delete) ข้อมูลกิจกรรม
- [x] **Priority Mapping:** กำหนดความสำคัญของงานได้ 3 ระดับ (ต่ำ, ปกติ, สูง) พร้อม Slider UI ที่ใช้งานง่าย
- [x] **Smart Status Tracking:** ติดตามสถานะกิจกรรมได้ 4 รูปแบบ (Pending, In Progress, Completed, Cancelled)
- [x] **Dynamic Color Sync:** สีของไอคอนกิจกรรมในหน้าหลักจะเปลี่ยนไปตามสีของหมวดหมู่ที่เลือกโดยอัตโนมัติ

### 3. ระบบความปลอดภัยและตรวจสอบข้อมูล
- [x] **Time Integrity Check:** ระบบแจ้งเตือน (SnackBar) และไม่อนุญาตให้บันทึก หากผู้ใช้ตั้งเวลาสิ้นสุด (End Time) มาก่อนเวลาเริ่ม (Start Time)
- [x] **Required Field Validation:** ตรวจสอบความครบถ้วนของข้อมูล (ชื่อกิจกรรมและหมวดหมู่) ก่อนทำการบันทึกลงฐานข้อมูล
- [x] **Referential Integrity:** ใช้ระบบ Foreign Key (PRAGMA) เพื่อควบคุมความสัมพันธ์ของข้อมูลระหว่างตาราง

### 4. ระบบกรองข้อมูลขั้นสูง
- [x] **Contextual Filter Chips:** กรองรายการกิจกรรมได้ทันทีผ่านแถบเมนูด้านบนหน้าจอ:
    - **All:** แสดงกิจกรรมทั้งหมด
    - **Today:** กรองเฉพาะกิจกรรมที่เกิดขึ้นในวันที่ปัจจุบัน (Real-time Date Filtering)
    - **Pending:** กรองเฉพาะงานที่รอดำเนินการ
    - **Completed:** กรองเฉพาะงานที่ทำเสร็จสิ้นแล้ว

### 5. ระบบแจ้งเตือนและตรวจสอบสถานะ
- [x] **Custom Reminders:** เลือกตั้งเวลาแจ้งเตือนล่วงหน้าได้หลากหลาย (0, 5, 15, 30, 60 นาที)
- [x] **Automated Debug Console:** ระบบแสดง Log ข้อมูลจาก SQLite ทุกครั้งที่มีการดึงข้อมูล (Fetch) ช่วยให้ผู้พัฒนาตรวจสอบค่าสถานะ (Status) และการแจ้งเตือน (Reminder) ได้ผ่าน Debug Console โดยไม่ต้องดึงไฟล์ Database ออกมา

---
## Project Structure (lib folder)
```bash
lib/
├── main.dart                 # จุดเริ่มต้นแอป (Setup MultiProvider)
├── data/
│   ├── db/
│   │   └── database_helper.dart  # จัดการ SQLite (Create Table, Upgrade)
│   └── models/
│       ├── category_model.dart   # Class ข้อมูลหมวดหมู่
│       └── event_model.dart      # Class ข้อมูลกิจกรรม
├── ui/
│   ├── screens/
│   │   ├── home_screen.dart             # หน้าหลัก (แสดงรายการ & Filter)
│   │   ├── event_form_screen.dart       # หน้าเพิ่ม/แก้ไขกิจกรรม (Validation)
│   │   └── category_management_screen.dart # หน้าจัดการหมวดหมู่ (Quick Add)
│   ├── state/
│   │   ├── event_provider.dart      # จัดการ Logic กิจกรรม (Filter & Debug Log)
│   │   └── category_provider.dart   # จัดการ Logic หมวดหมู่
│   └── widgets/
│       └── event_card.dart          # (Optional) Widget แยกสำหรับแสดงรายการ
```

## Getting Started

1. **ติดตั้ง Dependencies:**
   ```bash
   flutter pub get
   ```
2. รันแอปพลิเคชั่น
   ```bash
   flutter run
   ```
--- 

## Database Schema

### 🔹 Table: categories (ตารางหมวดหมู่)
| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | ไอดีหลักของหมวดหมู่ |
| name | TEXT | NOT NULL | ชื่อหมวดหมู่ (เช่น ประชุม, งานด่วน) |
| color_hex | TEXT | NOT NULL | รหัสสี HEX สำหรับแสดงผลในแอป |
| icon_key | TEXT | NOT NULL | คีย์สำหรับเลือกไอคอนที่เกี่ยวข้อง |

### 🔹 Table: events (ตารางกิจกรรม)
| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | ไอดีหลักของกิจกรรม |
| title | TEXT | NOT NULL | ชื่อกิจกรรม |
| description | TEXT | - | รายละเอียดเพิ่มเติม |
| category_id | INTEGER | FOREIGN KEY REFERENCES categories(id) | ไอดีอ้างอิงหมวดหมู่ |
| event_date | TEXT | NOT NULL | วันที่จัดกิจกรรม (YYYY-MM-DD) |
| start_time | TEXT | NOT NULL | เวลาเริ่ม (HH:mm) |
| end_time | TEXT | NOT NULL | เวลาสิ้นสุด (HH:mm) |
| status | TEXT | DEFAULT 'pending' | สถานะ (pending, in_progress, completed, cancelled) |
| priority | INTEGER | DEFAULT 2 | ระดับความสำคัญ (1=Low, 2=Medium, 3=High) |
| reminder_minutes | INTEGER | DEFAULT 15 | จำนวนนาทีที่ตั้งแจ้งเตือนล่วงหน้า |

### 🔹 Table: reminders (ตารางการแจ้งเตือน)
| Column | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | ไอดีหลักของแจ้งเตือน |
| event_id | INTEGER | FOREIGN KEY REFERENCES events(id) ON DELETE CASCADE | ไอดีอ้างอิงกิจกรรม |
| minutes_before | INTEGER | - | จำนวนนาทีแจ้งเตือนล่วงหน้า |
| is_enabled | INTEGER | DEFAULT 1 | 1 = เปิดใช้งาน, 0 = ปิดใช้งาน |

---

### ขั้นตอนการทดสอบ
| เพิ่มประเภทกิจกรรม 3 ประเภท | เพิ่มกิจกรรม 5 รายการ | ทดสอบ validation | กรองรายการกิจกรรมตามประเภท |
| :---: | :---: | :---: | :---: |
| <img width="300" height="900" src="https://github.com/user-attachments/assets/607b7c5f-0f9f-4bc4-8796-70967f343879" /> | <img width="300" height="900" src="https://github.com/user-attachments/assets/bce29e1f-2a56-4ead-af44-43c2cb8a2e73" /> | <img width="300" height="900" src="https://github.com/user-attachments/assets/c0c777bc-6938-4781-844d-790ca1fd4bf0" /> | <img width="300" height="900" src="https://github.com/user-attachments/assets/0a8d8a1e-47c5-4d15-85d5-e280cf66791e" /> |

| | Pending → Completed |  |
| :---: | :---: | :---: |
| <img width="300" height="550" src="https://github.com/user-attachments/assets/50947fbb-8849-4fa7-a385-a722dad748fa" /> | <img width="300" height="700" src="https://github.com/user-attachments/assets/a3c2d58c-2887-448a-bc80-f94788538aba" /> | <img width="300" height="700" src="https://github.com/user-attachments/assets/57e2362b-f45e-467d-bb9b-e7ff2585c55d" /> |

| เปิด/ปิดการแจ้งเตือน |  ตรวจสอบว่าค่าใน DB |
| :---: | :---: |
| <img width="1200" height="700" src="https://github.com/user-attachments/assets/072577b5-76ca-4770-ba27-3088225d9c9e" /> | <img width="1200" height="700" src="https://github.com/user-attachments/assets/d8c6afda-454f-4262-8b52-0e98c7482b09" /> |
