import 'package:dio/dio.dart';
import 'package:dotto/api/api_environment.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final apiClientProvider = Provider<Openapi>(
  (ref) => Openapi(
    basePathOverride: ref.watch(apiEnvironmentProvider).basePath,
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint('Request: ${options.method} ${options.uri}');
          final appCheckToken = await FirebaseAppCheck.instance.getToken();
          if (appCheckToken != null) {
            options.headers['X-Firebase-AppCheck'] = 'Bearer $appCheckToken';
          }
          final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
          if (idToken != null) {
            options.headers['Authorization'] = 'Bearer $idToken';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            'Response: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint(
            'Response: ${error.response?.statusCode} ${error.requestOptions.method} ${error.requestOptions.uri}',
          );
          return handler.next(error);
        },
      ),
    ],
  ),
);
