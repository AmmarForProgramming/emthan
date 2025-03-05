import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// **🟢 تهيئة الإشعارات**
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  /// **🟢 إرسال إشعار بدون صوت**
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    // **إعدادات الإشعار**
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'sales_channel', // 🔹 معرف القناة (يجب أن يكون معرفًا فريدًا)
      'إشعارات المبيعات',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false, // ❌ تعطيل الصوت
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // **إرسال الإشعار**
    await _notificationsPlugin.show(
      0, // 🔹 رقم الإشعار
      title,
      body,
      notificationDetails,
    );
  }
}