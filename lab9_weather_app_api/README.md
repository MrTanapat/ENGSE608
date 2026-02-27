# 🌤️ Weather App (Flutter + Provider + Open-Meteo API)

แอปพลิเคชันพยากรณ์อากาศที่พัฒนาด้วย Flutter แสดงข้อมูลสภาพอากาศปัจจุบันและพยากรณ์ล่วงหน้า 10 วัน โดยดึงข้อมูลจาก Open-Meteo API พร้อมระบบค้นหาจังหวัดและเปลี่ยนสี UI ตามอุณหภูมิ

## ✨ คุณสมบัติ (Features)

* **Current Weather**: แสดงอุณหภูมิปัจจุบันและรหัสสภาพอากาศ (Weather Code)
* **10-Day Forecast**: แสดงพยากรณ์อากาศล่วงหน้า 10 วัน (อุณหภูมิสูงสุด/ต่ำสุด)
* **Location Search**: ค้นหาสภาพอากาศตามชื่อจังหวัดหรือเมือง (ภาษาอังกฤษ) ทั่วโลก
* **Dynamic Background**: สีพื้นหลังของแอปจะเปลี่ยนตามอุณหภูมิ (ส้ม = ร้อน, ฟ้า = ปกติ, เทา/น้ำเงิน = หนาว)
* **Tab Switching**: เลือกระหว่างการดูสภาพอากาศปัจจุบันหรือพยากรณ์ล่วงหน้าผ่าน Segmented Button

## 🛠️ เทคโนโลยีที่ใช้ (Tech Stack)

* **Flutter**: Framework หลักในการพัฒนา
* **Provider**: การจัดการสถานะ (State Management) แบบมีประสิทธิภาพ
* **HTTP**: สำหรับเรียกใช้งาน REST API จากภายนอก
* **Open-Meteo API**: บริการข้อมูลสภาพอากาศฟรี (Geocoding & Forecast)

## 📁 โครงสร้างโปรเจ็กต์ (Project Structure)

```text
lib/
├── models/      # คลาสสำหรับแปลงข้อมูล JSON (Weather & Forecast)
├── providers/   # จัดการ Logic และ State ของแอป (WeatherProvider)
├── screens/     # หน้าจอ UI (WeatherHomeScreen)
├── services/    # ตัวเชื่อมต่อ API (WeatherService)
└── main.dart    # จุดเริ่มต้นของแอปและ MultiProvider Setup
```

## 🚀 วิธีการติดตั้ง (Installation)

1.  **Clone โปรเจ็กต์**:
    ```bash
    git clone <your-repository-url>
    cd lab9_weather_app_api
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

## 📝 บันทึกการพัฒนา
โปรเจ็กต์นี้เป็นส่วนหนึ่งของวิชาห้องปฏิบัติการ (Lab 9) เน้นการเรียนรู้เรื่องการใช้งาน **Asynchronous Programming**, **API Integration**, และ **Provider Pattern** ใน Flutter

---
สร้างด้วย ❤️ โดย Gemini AI และทีมพัฒนา
