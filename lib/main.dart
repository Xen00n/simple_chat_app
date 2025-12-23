import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:simple_chat_app/features/auth/loginpage.dart';
import 'package:simple_chat_app/features/auth/validationpage.dart';
import 'package:simple_chat_app/features/chat/chatlistpage.dart';
import 'package:simple_chat_app/features/chat/chatpage.dart';
import 'package:simple_chat_app/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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
    GoRoute(
      name: "ChatPage",
      path: '/chat/:chatId',
      builder: (context, state) =>
          ChatPage(chatId: state.pathParameters['chatId']),
    ),
  ],
);

class MyRouter extends StatelessWidget {
  const MyRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
