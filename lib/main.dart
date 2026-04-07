import 'dart:async';

import 'package:dotto/api/api_environment.dart';
import 'package:dotto/app.dart';
import 'package:dotto/firebase_options.dart';
import 'package:dotto/helper/firebase_auth_helper.dart';
import 'package:dotto/helper/firebase_storage_repository.dart';
import 'package:dotto/helper/location_helper.dart';
import 'package:dotto/helper/logger.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase Crashlytics
  // Debugモードではクラッシュレポートを送信しない
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    !kDebugMode,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
    );
    return true;
  };

  // Firebase App Check
  await FirebaseAppCheck.instance.activate(
    providerApple: kReleaseMode
        ? const AppleAppAttestProvider()
        : const AppleDebugProvider(),
    providerAndroid: kReleaseMode
        ? const AndroidPlayIntegrityProvider()
        : const AndroidDebugProvider(),
  );

  // Firebase Authentication
  await FirebaseAuthHelper.initialize();

  // Firebase Messaging
  // 通知許可をリクエスト
  await FirebaseMessaging.instance.requestPermission(provisional: true);
  // バックグラウンドハンドラーを設定
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 位置情報の許可をリクエスト
  await LocationHelper.requestLocationPermission();

  // ローカルタイムゾーンの設定
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

  // 画面の向きを固定
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ファイルをダウンロード
  try {
    await FirebaseStorageRepository().download('funch/menu.json');
  } on Exception catch (e, stack) {
    await LoggerImpl().logError(
      e,
      stack,
      reason: 'Failed to download menu.json',
    );
  }

  // アプリの起動ログを送信
  await LoggerImpl().logAppOpen();

  // アプリの起動
  final container = ProviderContainer();
  await container.read(apiEnvironmentProvider.notifier).loadOverride();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
