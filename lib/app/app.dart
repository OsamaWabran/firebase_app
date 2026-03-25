import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class FirebaseMessagingApp extends StatelessWidget {
  const FirebaseMessagingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FCM Lab',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
