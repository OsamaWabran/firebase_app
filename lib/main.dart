import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await requestPermission(); // طلب الإذن
  await getToken();          // جلب التوكن

  runApp(const MainApp());
}

// طلب إذن الإشعارات
Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission();

  print('Permission: ${settings.authorizationStatus}');
}

// جلب التوكن
Future<void> getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("TOKEN: $token");
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  void initState() {
    super.initState();

    // استقبال الإشعارات والتطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 رسالة جديدة!');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    });

    // لما المستخدم يضغط على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🚀 المستخدم ضغط على الإشعار');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('Firebase Notifications Ready 🔔')),
      ),
    );
  }
}