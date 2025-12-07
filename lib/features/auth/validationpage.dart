import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat_app/data_model/user_model.dart';
import 'package:simple_chat_app/data_provider/user_provider.dart';

class ValidationPage extends ConsumerStatefulWidget {
  const ValidationPage({super.key});

  @override
  ConsumerState<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends ConsumerState<ValidationPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString("userId");
    final savedUserName = prefs.getString("userName");
    if (!mounted) return;

    if ((savedUserId != null && savedUserName != null) &&
        (savedUserName != '' && savedUserId != '')) {
      ref.read(userProvider.notifier).state = User(
        id: savedUserId,
        name: savedUserName,
      );
      GoRouter.of(context).go('/chatlist');
    } else {
      GoRouter.of(context).go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
