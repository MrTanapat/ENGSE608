import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.login(_userController.text, _passController.text);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ยินดีต้อนรับ ${auth.user?.username}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login ไม่สำเร็จ กรุณาลองใหม่')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 20),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Username (johnd)'),
            ),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'Password (m38rmn=)'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text('เข้าสู่ระบบ'),
                  ),
          ],
        ),
      ),
    );
  }
}
