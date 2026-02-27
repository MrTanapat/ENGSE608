import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import Providers
import 'ui/state/event_provider.dart';
import 'ui/state/category_provider.dart';
// Import Screens
import 'ui/screens/home_screen.dart';

void main() async {
  // บรรทัดนี้สำคัญมากเมื่อมีการเรียกใช้ Plugin (เช่น SQLite) ก่อนสั่ง runApp
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        // ลงทะเบียน Provider ทั้งหมดเพื่อให้เข้าถึงได้ทั้งแอป
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event & Reminder App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        // ตั้งค่า ColorScheme ให้ดูทันสมัยตาม Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
      ),
      // หน้าแรกของแอป
      home: HomeScreen(),
    );
  }
}
