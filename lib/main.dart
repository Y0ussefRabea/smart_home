import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/UI/auth/auth_wrapper.dart';
import 'package:smart_home/UI/auth/login.dart';
import 'package:smart_home/UI/auth/register.dart';
import 'package:smart_home/UI/home/home.dart';
import 'package:smart_home/providers/smart_home_provider.dart';
import 'package:smart_home/utils/app_routes.dart';
import 'UI/auth/forgot_password.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';

///background notifications handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  print('Background message received');
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();// this makes the runApp function and firebase work simultaneously to prevent errors
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );

///firebase messaging initialize
  await NotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await FirebaseMessaging.instance.requestPermission();
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM TOKEN: $token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationService.showNotification(
      title: message.notification?.title ?? 'Smart Home Alert',
      body: message.notification?.body ?? '',
    );
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SmartHomeProvider()..startListening(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
        routes: {
          AppRoutes.loginRouteName:(context)=>LoginScreen(),
          AppRoutes.forgotPassRouteName:(context)=>ForgotPasswordScreen(),
          AppRoutes.registerRouteName:(context)=>RegisterScreen(),
          AppRoutes.homeRouteName:(context)=>HomeScreen()
        },
      ),
    );
  }
}
