import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final String title =
      message.notification?.title ?? message.data['title']?.toString() ?? '';
  final String body =
      message.notification?.body ?? message.data['body']?.toString() ?? '';

  debugPrint(
    'Background message received: ${message.messageId} | $title | $body',
  );
}
