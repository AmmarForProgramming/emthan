import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
//import '../providers/notifications_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<NotificationsProvider>(context);
WidgetsBinding.instance.addPostFrameCallback((_){
  notificationsProvider.fetchNotifications();
});
    return Scaffold(
      appBar: AppBar(title: const Text("الإشعارات")),
      body: ListView.builder(
        itemCount: notificationsProvider.notifications.length,
        itemBuilder: (context, index) {
          final notification = notificationsProvider.notifications[index];
          return ListTile(
            title: Text(notification['title']),
            subtitle: Text(notification['body']),
            trailing: notification['is_read'] == 0
  ? const Icon(Icons.circle, color: Colors.red, size: 10)
                : null,
            onTap: () {
              notificationsProvider.markAsRead(notification['id']);
            },
          );
        },
      ),
    );
  }
}
