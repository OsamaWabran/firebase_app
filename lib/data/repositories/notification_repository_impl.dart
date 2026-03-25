import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../services/firebase_messaging_service.dart';
import '../services/local_notification_service.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required FirebaseMessagingService firebaseMessagingService,
    required LocalNotificationService localNotificationService,
  }) : _firebaseMessagingService = firebaseMessagingService,
       _localNotificationService = localNotificationService;

  final FirebaseMessagingService _firebaseMessagingService;
  final LocalNotificationService _localNotificationService;

  @override
  Future<String?> getFcmToken() {
    return _firebaseMessagingService.getToken();
  }

  @override
  Stream<NotificationEntity> listenToNotifications() {
    return _firebaseMessagingService.observeNotifications();
  }

  @override
  Future<bool> requestPermission() async {
    await _localNotificationService.requestPermission();
    return _firebaseMessagingService.requestPermission();
  }
}
