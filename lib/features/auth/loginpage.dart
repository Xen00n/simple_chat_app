import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat_app/data_model/user_model.dart';
import 'package:simple_chat_app/data_provider/user_provider.dart';
import 'package:simple_chat_app/features/perm/requestpermissionandgettoken.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  String username = "";
  String? token = "";
  Future<bool> login() async {
    if (username.isNotEmpty) {
      final user = User(id: "thisisdummyid", name: "TesterHo");
      ref.read(userProvider.notifier).state = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", user.id);
      await prefs.setString("userName", user.name);
      token = await requestPermissionAndGetToken();
      print(token);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Username'),
            onChanged: (value) => {username = value},
          ),
          TextButton(
            onPressed: () async {
              if (await login()) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Login Successful $token')),
                );
                GoRouter.of(context).go('/chatlist');
              } else {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Login Failed')));
              }
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
