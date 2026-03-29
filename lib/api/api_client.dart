import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dotto/api/api_environment.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

Future<String?> _getIdTokenForRequest() async {
  final currentToken = await FirebaseAuth.instance.currentUser?.getIdToken();
  if (currentToken != null && currentToken.isNotEmpty) {
    return currentToken;
  }

  try {
    final nextUser = await FirebaseAuth.instance
        .idTokenChanges()
        .firstWhere((user) => user != null)
        .timeout(const Duration(seconds: 2));
    final nextToken = await nextUser?.getIdToken();
    if (nextToken != null && nextToken.isNotEmpty) {
      return nextToken;
    }
  } on TimeoutException {
    debugPrint('ID token wait timed out');
  }

  final refreshedToken = await FirebaseAuth.instance.currentUser?.getIdToken(true);
  if (refreshedToken != null && refreshedToken.isNotEmpty) {
    return refreshedToken;
  }

  return null;
}

final apiClientProvider = Provider<Openapi>(
  (ref) => Openapi(
    basePathOverride: ref.watch(apiEnvironmentProvider).basePath,
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint('onRequest: ${options.uri}');
          final appCheckToken = await FirebaseAppCheck.instance.getToken();
          if (appCheckToken != null) {
            options.headers['X-Firebase-AppCheck'] = 'Bearer $appCheckToken';
          }
          final idToken = await _getIdTokenForRequest();
          if (idToken != null) {
            options.headers['Authorization'] = 'Bearer $idToken';
          }
          return handler.next(options);
        },
      ),
    ],
  ),
);
