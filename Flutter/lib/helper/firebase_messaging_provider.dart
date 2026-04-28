import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StreamProvider<String> fcmTokenRefreshStreamProvider =
    StreamProvider<String>((ref) {
      return FirebaseMessaging.instance.onTokenRefresh;
    });
