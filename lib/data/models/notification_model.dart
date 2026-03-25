import 'package:firebase_messaging/firebase_messaging.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({required super.title, required super.body});

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    final String title =
        message.notification?.title?.trim() ??
        message.data['title']?.toString().trim() ??
        'New Notification';
    final String body =
        message.notification?.body?.trim() ??
        message.data['body']?.toString().trim() ??
        'A new Firebase Cloud Messaging event has been received.';

    return NotificationModel(
      title: title.isEmpty ? 'New Notification' : title,
      body: body.isEmpty
          ? 'A new Firebase Cloud Messaging event has been received.'
          : body,
    );
  }
}
