import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('الإعدادات')),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('تعديل بيانات المستخدم'),
            onTap: () {
              // تنفيذ تعديل بيانات المستخدم
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('تغيير اللغة'),
            onTap: () {
              // تنفيذ تغيير اللغة
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('الإشعارات'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // تنفيذ تشغيل/إيقاف الإشعارات
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('تسجيل الخروج'),
            onTap: () {
              authProvider.logout();
            },
          ),
        ],
      ),
    );
  }
}
