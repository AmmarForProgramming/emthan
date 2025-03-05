import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';

class NotificationsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;

  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  Future<void> fetchNotifications() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('notifications', orderBy: 'date DESC');

    _notifications = result;
    _unreadCount = result.where((n) => n['is_read'] == 0).length;

    notifyListeners();
  }

  Future<void> addNotification(String title, String body) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('notifications', {
      'title': title,
      'body': body,
      'date': DateTime.now().toIso8601String(),
      'is_read': 0,
    });
    await fetchNotifications();
  }

  Future<void> markAsRead(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
   await fetchNotifications();
  }

  Future<void> clearNotifications() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('notifications');
   await fetchNotifications();
  }
}