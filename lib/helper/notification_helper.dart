import 'package:dotto/helper/url_launcher_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationHelperProvider = Provider<NotificationHelper>(
  (ref) => NotificationHelperImpl(),
);

abstract class NotificationHelper {
  Future<void> setupInteractedMessage();
}

final class NotificationHelperImpl implements NotificationHelper {
  factory NotificationHelperImpl() {
    return _instance;
  }
  NotificationHelperImpl._internal();
  static final NotificationHelperImpl _instance =
      NotificationHelperImpl._internal();

  @override
  Future<void> setupInteractedMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final url = message.data['url'];
    if (url != null) {
      launchUrlSafely(url as String);
    }
  }
}
