import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService(this._plugin);

  static const AndroidNotificationChannel notificationChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Foreground notifications for Firebase Cloud Messaging.',
        importance: Importance.max,
      );

  final FlutterLocalNotificationsPlugin _plugin;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
          macOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        );

    await _plugin.initialize(settings: initializationSettings);
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(notificationChannel);

    _isInitialized = true;
  }

  Future<void> requestPermission() async {
    await initialize();
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await initialize();

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        notificationChannel.id,
        notificationChannel.name,
        channelDescription: notificationChannel.description,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
