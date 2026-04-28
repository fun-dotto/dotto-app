import 'dart:async';

import 'package:dotto/domain/notification_alert_status.dart';
import 'package:dotto/helper/url_launcher_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

final notificationHelperProvider = Provider<NotificationHelper>(
  (ref) => NotificationHelperImpl(),
);

abstract class NotificationHelper {
  Future<void> setupInteractedMessage();
  Future<NotificationAlertStatus> fetchAlertStatus();
  Future<bool> openSystemSettings();
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
      unawaited(_handleMessage(initialMessage));
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  @override
  Future<NotificationAlertStatus> fetchAlertStatus() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    return NotificationAlertStatus.fromSettings(settings);
  }

  @override
  Future<bool> openSystemSettings() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // UIApplication.openSettingsURLString に相当。アプリ別の設定ページが開く。
      final opened = await launchUrlSafely(
        'app-settings:',
        mode: LaunchMode.externalApplication,
      );
      if (opened) return true;
    }
    // Android はGeolocatorが Settings.ACTION_APPLICATION_DETAILS_SETTINGS を呼ぶ。
    // iOS でurl_launcherが失敗した場合のフォールバックも兼ねる。
    return Geolocator.openAppSettings();
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final url = message.data['url'];
    if (url != null) {
      await launchUrlSafely(url as String);
    }
  }
}
