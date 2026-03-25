import 'package:get/get.dart';

import '../../presentation/bindings/notification_binding.dart';
import '../../presentation/pages/home_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<HomePage>(
      name: AppRoutes.home,
      page: HomePage.new,
      binding: NotificationBinding(),
    ),
  ];
}
