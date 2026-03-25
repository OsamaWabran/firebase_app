import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../data/repositories/notification_repository_impl.dart';
import '../../data/services/firebase_messaging_service.dart';
import '../../data/services/local_notification_service.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_fcm_token_use_case.dart';
import '../../domain/usecases/listen_to_notifications_use_case.dart';
import '../../domain/usecases/request_permission_use_case.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin.new,
      fenix: true,
    );
    Get.lazyPut<FirebaseMessaging>(
      () => FirebaseMessaging.instance,
      fenix: true,
    );
    Get.lazyPut<LocalNotificationService>(
      () =>
          LocalNotificationService(Get.find<FlutterLocalNotificationsPlugin>()),
      fenix: true,
    );
    Get.lazyPut<FirebaseMessagingService>(
      () => FirebaseMessagingService(
        messaging: Get.find<FirebaseMessaging>(),
        localNotificationService: Get.find<LocalNotificationService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(
        firebaseMessagingService: Get.find<FirebaseMessagingService>(),
        localNotificationService: Get.find<LocalNotificationService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<GetFcmTokenUseCase>(
      () => GetFcmTokenUseCase(Get.find<NotificationRepository>()),
      fenix: true,
    );
    Get.lazyPut<RequestPermissionUseCase>(
      () => RequestPermissionUseCase(Get.find<NotificationRepository>()),
      fenix: true,
    );
    Get.lazyPut<ListenToNotificationsUseCase>(
      () => ListenToNotificationsUseCase(Get.find<NotificationRepository>()),
      fenix: true,
    );
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        getFcmTokenUseCase: Get.find<GetFcmTokenUseCase>(),
        requestPermissionUseCase: Get.find<RequestPermissionUseCase>(),
        listenToNotificationsUseCase: Get.find<ListenToNotificationsUseCase>(),
      ),
    );
  }
}
