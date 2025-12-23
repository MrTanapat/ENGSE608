# Lab Dart03 : OOP Product Management System

## โครงสร้างคลาส

### 1. Product (Class แม่)

**Properties**

* `_id` : String (private)
* `name` : String
* `_price` : double (ควบคุมผ่าน setter)
* `stock` : int? (nullable)

**Methods**

* `applyDiscount(double percent)`
* `restock(int amount)`
* `showInfo()`

### 2. DigitalProduct (extends Product)

**Property เพิ่มเติม**

* `fileSizeMB` : double

**Override Method**

* `showInfo()` แสดงประเภทสินค้าและขนาดไฟล์

### 3. FoodProduct (extends Product)

**Property เพิ่มเติม**

* `expireDate` : String

**Override Method**

* `showInfo()` แสดงประเภทสินค้าและวันหมดอายุ

## Polymorphism

ใช้ `List<Product>` เก็บสินค้าได้หลายประเภท และเรียก `showInfo()` ผ่าน object ของคลาสแม่ แต่แสดงผลตามคลาสลูกที่ถูก override

---

## ตัวอย่างการทำงานของระบบ

<img width="500" height="500" alt="image" src="https://github.com/user-attachments/assets/436e9d1d-1d1e-4439-97f9-276d2b1f29bb" />


## ผู้จัดทำ
67543210031-0 ธนภัทร นุกูล
