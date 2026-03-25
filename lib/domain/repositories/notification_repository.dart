import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<bool> requestPermission();

  Future<String?> getFcmToken();

  Stream<NotificationEntity> listenToNotifications();
}
