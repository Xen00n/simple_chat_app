import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat_app/data_provider/user_provider.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  String get username =>
      ref.watch(userProvider.select((user) => user?.name ?? 'Guest'));
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
              if (!mounted) return;
              GoRouter.of(context).go('/login');
            },
          ),
        ],
      ),
      body: Center(child: Text('Welcome to the Chat List Page! $username')),
    );
  }
}
