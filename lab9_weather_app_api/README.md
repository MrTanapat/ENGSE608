# 🌤️ Weather App (Flutter + Provider + Open-Meteo API)

แอปพลิเคชันพยากรณ์อากาศที่พัฒนาด้วย Flutter แสดงข้อมูลสภาพอากาศปัจจุบันและพยากรณ์ล่วงหน้า 10 วัน โดยดึงข้อมูลจาก Open-Meteo API

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

## ขั้นตอนการทดสอบ
| หน้าแรก(Current) | พยากรล่วงหน้า 10 วัน | ค้นหาสภาพอากาศ | ปรับสีพื้นหลังตามสภาพอากาศ |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/ce418a37-ace4-4a96-bbb6-81aeccd3037d" width="200" /> | <img src="https://github.com/user-attachments/assets/f6206d69-4db8-4bd4-b1f9-d6b7f4710e38" width="200" /> | <img src="https://github.com/user-attachments/assets/acabf19e-ad7e-4d6c-b4ef-5392bd1c24bb" width="200" /> | <img src="https://github.com/user-attachments/assets/1bdfe2a6-86bf-47dd-9fa7-fd9dfe3bd8d8" width="200" /> |


---
