import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat_app/data_provider/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  String get username =>
      ref.watch(userProvider.select((user) => user?.name ?? 'Guest'));
  @override
  void initState() {
    super.initState();
    _listenToForegroundMessages();
  }

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'New message';
      final body = message.notification?.body ?? '';

      showSimpleNotification(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(body, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        background: Colors.black87,
        elevation: 4,
        slideDismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 4),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString("userId", "");
              await prefs.setString("userName", "");
              ref.read(userProvider.notifier).state = null;
              if (!context.mounted) return;
              GoRouter.of(context).go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(child: Text('Welcome to the Chat List Page! $username')),
          ElevatedButton(
            onPressed: () => {GoRouter.of(context).go('/chat/sampleChatId')},
            child: Text("chatpage"),
          ),
        ],
      ),
    );
  }
}
