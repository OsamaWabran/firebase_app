import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/notification_model.dart';
import 'local_notification_service.dart';

class FirebaseMessagingService {
  FirebaseMessagingService({
    required FirebaseMessaging messaging,
    required LocalNotificationService localNotificationService,
  }) : _messaging = messaging,
       _localNotificationService = localNotificationService;

  final FirebaseMessaging _messaging;
  final LocalNotificationService _localNotificationService;

  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) {
      return;
    }

    await _localNotificationService.initialize();
    await _messaging.setAutoInitEnabled(true);
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    await _ensureInitialized();

    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<String?> getToken() async {
    await _ensureInitialized();
    return _messaging.getToken();
  }

  Stream<NotificationModel> observeNotifications() {
    final StreamController<NotificationModel> controller =
        StreamController<NotificationModel>();

    StreamSubscription<RemoteMessage>? onMessageSubscription;
    StreamSubscription<RemoteMessage>? onMessageOpenedSubscription;

    controller.onListen = () {
      unawaited(
        Future<void>(() async {
          try {
            await _ensureInitialized();

            final RemoteMessage? initialMessage = await _messaging
                .getInitialMessage();
            if (initialMessage != null) {
              controller.add(
                NotificationModel.fromRemoteMessage(initialMessage),
              );
            }

            onMessageSubscription = FirebaseMessaging.onMessage.listen((
              RemoteMessage message,
            ) async {
              final NotificationModel notification =
                  NotificationModel.fromRemoteMessage(message);

              await _localNotificationService.showNotification(
                title: notification.title,
                body: notification.body,
              );

              controller.add(notification);
            });

            onMessageOpenedSubscription = FirebaseMessaging.onMessageOpenedApp
                .listen((RemoteMessage message) {
                  controller.add(NotificationModel.fromRemoteMessage(message));
                });
          } catch (error, stackTrace) {
            controller.addError(error, stackTrace);
          }
        }),
      );
    };

    controller.onCancel = () async {
      await onMessageSubscription?.cancel();
      await onMessageOpenedSubscription?.cancel();
    };

    return controller.stream;
  }
}
