# Lab10-API DataManagement (CRUD)

## 🎯 วัตถุประสงค์ของโปรเจกต์
- เชื่อมต่อและดึงข้อมูลจาก REST API แบบ Asynchronous
- จัดการสถานะของแอปพลิเคชัน (Auth, Product, Cart) ด้วย **Provider**
- ออกแบบระบบ **Role-based Access Control (RBAC)** โดยแยกสิทธิ์ระหว่าง Admin และ User
- พัฒนาระบบตระกร้าสินค้า (Cart System) ที่สามารถคำนวณราคาแบบ Real-time

---

## ✨ คุณสมบัติ (Features)
* **ระบบ Authentication**: ตรวจสอบผู้ใช้งานผ่าน FakeStoreAPI พร้อมระบบจัดการ Token เบื้องต้น
* **Role-based Access Control (RBAC)**: 
    * **Admin (ID = 1)**: สามารถมองเห็นปุ่ม Admin Panel เพื่อดูรายชื่อผู้ใช้งานทั้งหมดในระบบได้ (ระบุเงื่อนไขเฉพาะ Username: johnd)
    * **User**: สามารถเลือกซื้อสินค้าและจัดการตะกร้าสินค้าได้ตามปกติ
* **ระบบรายการสินค้า**: แสดงสินค้าทั้งหมดจาก API ในรูปแบบ Grid View พร้อมภาพประกอบและราคา
* **หน้ารายละเอียดสินค้า**: แสดงข้อมูลคำอธิบายสินค้าแบบเต็ม (Description) และปุ่มสั่งซื้อ
* **ระบบตะกร้าสินค้า (Shopping Cart)**: 
    * เพิ่ม/ลด จำนวนสินค้าในตะกร้า
    * คำนวณราคาสินค้าแยกตามรายการและราคารวมสุทธิแบบ Real-time
    * ระบบ Badge แจ้งเตือนจำนวนสินค้าบนไอคอนรถเข็น

---

## 🛠️ เทคโนโลยีที่ใช้ (Tech Stack)
* **Framework**: Flutter (3.x)
* **Language**: Dart
* **State Management**: Provider
* **API Connection**: HTTP Client
* **Backend API**: [FakeStoreAPI](https://fakestoreapi.com/)

## 🏗️ โครงสร้างโปรเจกต์ (Project Structure)
## 📂 โครงสร้างโปรเจ็กต์ (Project Structure)
```text
lib/
├── models/             # ไฟล์คำจำกัดความข้อมูล (Data Models)
│   ├── user_model.dart
│   ├── product_model.dart
│   └── cart_model.dart
├── services/           # ไฟล์เชื่อมต่อ API
│   └── api_service.dart
├── providers/          # ส่วนจัดการ State (Logic)
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   └── cart_provider.dart
├── screens/            # หน้าจอ UI ต่างๆ
│   ├── login_screen.dart
│   ├── product_list_screen.dart
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart
│   └── admin_screen.dart
└── main.dart           # จุดเริ่มต้นของแอปพลิเคชันและการตั้งค่า Provider
```

---

## 📡 API Endpoints ที่ใช้งาน
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| **POST** | `/auth/login` | ตรวจสอบสิทธิ์และรับ Token |
| **GET** | `/products` | ดึงรายการสินค้าทั้งหมด |
| **GET** | `/users` | ดึงรายชื่อผู้ใช้ทั้งหมด (เฉพาะ Admin) |

---

## 🛠️ วิธีการติดตั้งและรัน
1. Clone repository นี้ลงเครื่อง
2. รันคำสั่ง `flutter pub get` เพื่อติดตั้ง dependencies
3. รันแอปพลิเคชันด้วย `flutter run`

### ข้อมูลสำหรับทดสอบ (FakeStoreAPI)
- **Admin**: Username: `johnd` | Password: `m38rmn=`
- **User**: Username: `mor_2314` | Password: `83r5^_`

## ขั้นตอนการทดสอบ
| login -> ไม่สำเร็จ | Admin login | User login | ตระกร้าสินค้า |
| :---: | :---: | :---: | :---: |
| <img width="400" src="https://github.com/user-attachments/assets/c9bebdfa-eba7-4184-993a-320a1cd2113e" />| <img width="400" src="https://github.com/user-attachments/assets/16b8c7ef-3c18-42eb-87fc-e3d4bb6f5bec" />| <img width="411"  src="https://github.com/user-attachments/assets/579b5353-28d0-4a37-b664-07ade43ad748" />| <img width="400" src="https://github.com/user-attachments/assets/57d1f38d-4074-4c0b-82f1-e40a969b27b9" />|

| เพื่มจำนวนสินค้า | Admin login | User login | ตระกร้าสินค้า |
| :---: | :---: | :---: | :---: |
| <img width="400" src="https://github.com/user-attachments/assets/9829c7d7-9c66-4d3f-ba3a-7c622a9757a9" />
| 
 | <img width="411"  src="https://github.com/user-attachments/assets/579b5353-28d0-4a37-b664-07ade43ad748" />| <img width="400" src="https://github.com/user-attachments/assets/57d1f38d-4074-4c0b-82f1-e40a969b27b9" />|

