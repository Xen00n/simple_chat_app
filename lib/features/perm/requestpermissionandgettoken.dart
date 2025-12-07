import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> requestPermissionAndGetToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional) {
    String? token = await messaging.getToken();
    return token;
    // Send to backend
  } else {
    // print("User declined or has not accepted permission");
    return "sad";
  }
}
