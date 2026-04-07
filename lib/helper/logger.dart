import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loggerProvider = Provider<Logger>((ref) => LoggerImpl());

abstract class Logger {
  Future<void> setup();
  Future<void> logAppOpen();
  Future<void> logLogin();
  Future<void> logLogout();
  Future<void> logError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  });
}

final class LoggerImpl implements Logger {
  factory LoggerImpl() {
    return _instance;
  }
  LoggerImpl._internal();
  static final LoggerImpl _instance = LoggerImpl._internal();

  @override
  Future<void> setup() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseAnalytics.instance.setUserId(id: userId);
    }
    debugPrint('[Logger] setup');
  }

  @override
  Future<void> logAppOpen() async {
    await FirebaseAnalytics.instance.logAppOpen();
    debugPrint('[Logger] app_open');
  }

  @override
  Future<void> logLogin() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseAnalytics.instance.setUserId(id: userId);
    await FirebaseAnalytics.instance.logLogin();
    debugPrint('[Logger] login');
  }

  @override
  Future<void> logLogout() async {
    await FirebaseAnalytics.instance.setUserId();
    debugPrint('[Logger] logout');
  }

  @override
  Future<void> logError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
    debugPrint('[Logger] error: $exception, reason: $reason, information: $information, fatal: $fatal');
  }
}
