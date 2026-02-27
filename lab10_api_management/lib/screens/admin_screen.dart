import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. ดึงข้อมูล User ปัจจุบันมาเช็คสิทธิ์อีกครั้งเพื่อความปลอดภัย
    final currentUser = context.read<AuthProvider>().user;
    final apiService = ApiService();

    // 2. ถ้าไม่ใช่ ID=1 ให้แสดงข้อความเตือน (ป้องกันการแอบเข้าผ่าน Navigator)
    if (currentUser?.id != 1) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Access Denied: Admin Only!',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel - User Management'),
        backgroundColor: Colors.red[50], // เพิ่มสีให้ดูต่างจากหน้าปกติ
      ),
      body: FutureBuilder<List<User>>(
        future: apiService.fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;
            return ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) =>
                  const Divider(), // เส้นคั่นระหว่างรายชื่อ
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: user.id == 1
                        ? Colors.red
                        : Colors.blueGrey,
                    child: Text(
                      '${user.id}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    user.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user.email),
                  trailing: user.id == 1
                      ? const Chip(
                          label: Text('ROOT'),
                          backgroundColor: Colors.amber,
                        )
                      : const Icon(Icons.person_outline),
                );
              },
            );
          }
        },
      ),
    );
  }
}
