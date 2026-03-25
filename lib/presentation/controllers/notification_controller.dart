import 'dart:async';

import 'package:get/get.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_fcm_token_use_case.dart';
import '../../domain/usecases/listen_to_notifications_use_case.dart';
import '../../domain/usecases/request_permission_use_case.dart';

class NotificationController extends GetxController {
  NotificationController({
    required GetFcmTokenUseCase getFcmTokenUseCase,
    required RequestPermissionUseCase requestPermissionUseCase,
    required ListenToNotificationsUseCase listenToNotificationsUseCase,
  }) : _getFcmTokenUseCase = getFcmTokenUseCase,
       _requestPermissionUseCase = requestPermissionUseCase,
       _listenToNotificationsUseCase = listenToNotificationsUseCase;

  final GetFcmTokenUseCase _getFcmTokenUseCase;
  final RequestPermissionUseCase _requestPermissionUseCase;
  final ListenToNotificationsUseCase _listenToNotificationsUseCase;

  final RxString token = ''.obs;
  final Rx<NotificationEntity?> lastNotification = Rx<NotificationEntity?>(
    null,
  );
  final RxString permissionStatus =
      'Permission has not been requested yet.'.obs;
  final RxString messagingStatus = 'Firebase Messaging is initializing.'.obs;
  final RxBool isRequestingPermission = false.obs;
  final RxBool isLoadingToken = false.obs;

  StreamSubscription<NotificationEntity>? _notificationSubscription;

  @override
  void onInit() {
    super.onInit();
    _startListeningToNotifications();
  }

  Future<void> requestPermission() async {
    if (isRequestingPermission.value) {
      return;
    }

    isRequestingPermission.value = true;

    try {
      final bool isGranted = await _requestPermissionUseCase();
      permissionStatus.value = isGranted
          ? 'Notification permission granted successfully.'
          : 'Notification permission was denied.';
    } catch (_) {
      permissionStatus.value = 'Failed to request notification permission.';
    } finally {
      isRequestingPermission.value = false;
    }
  }

  Future<void> fetchToken() async {
    if (isLoadingToken.value) {
      return;
    }

    isLoadingToken.value = true;

    try {
      token.value = await _getFcmTokenUseCase() ?? 'Token is unavailable.';
    } catch (_) {
      token.value = 'Failed to load FCM token.';
    } finally {
      isLoadingToken.value = false;
    }
  }

  void _startListeningToNotifications() {
    _notificationSubscription = _listenToNotificationsUseCase().listen(
      (NotificationEntity notification) {
        lastNotification.value = notification;
        messagingStatus.value =
            'A notification has been received successfully.';
      },
      onError: (_) {
        messagingStatus.value =
            'An error occurred while listening for FCM events.';
      },
    );

    messagingStatus.value = 'Firebase Messaging is ready to receive events.';
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    super.onClose();
  }
}
