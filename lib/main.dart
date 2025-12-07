import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_chat_app/features/auth/loginpage.dart';
import 'package:simple_chat_app/features/auth/validationpage.dart';
import 'package:simple_chat_app/features/chat/chatlistpage.dart';

void main() {
  runApp(
    const ProviderScope(
      // <-- wrap your app here
      child: MyRouter(),
    ),
  );
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
