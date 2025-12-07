import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat_app/features/auth/loginpage.dart';
import 'package:simple_chat_app/features/auth/validationpage.dart';
import 'package:simple_chat_app/features/chat/chatlistpage.dart';
import 'package:simple_chat_app/firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message: ${message.notification?.title}');
    // Show a SnackBar or in-app notification
  });
  runApp(const ProviderScope(child: MyRouter()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      name: "Validator",
      path: '/',
      builder: (context, state) => const ValidationPage(),
    ),
    GoRoute(
      path: "/login",
      name: "Login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: "ChatList",
      path: '/chatlist',
      builder: (context, state) => const ChatListPage(),
    ),
  ],
);

class MyRouter extends StatelessWidget {
  const MyRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
