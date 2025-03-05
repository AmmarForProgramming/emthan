import 'package:flutter/material.dart';
//import 'auth/register_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الملف الشخصي"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple.shade200,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "اسم المستخدم",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "email@example.com",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.deepPurple.shade100),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.deepPurple),
              title: Text("الإعدادات"),
              onTap: () {
                // فتح صفحة الإعدادات
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("تسجيل الخروج"),
              onTap: () {
                // تنفيذ تسجيل الخروج
              },
            ),
          ],
        ),
      ),
    );
  }
}
