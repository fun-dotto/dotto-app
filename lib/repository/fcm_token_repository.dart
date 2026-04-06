import 'package:dotto/api/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

abstract class FCMTokenRepository {
  Future<void> upsertToken({required String token});
}

final class FCMTokenRepositoryImpl implements FCMTokenRepository {
  FCMTokenRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<void> upsertToken({required String token}) async {
    try {
      final api = ref.read(apiClientProvider).getFCMTokensApi();
      await api.fCMTokenV1Upsert(fCMTokenRequest: FCMTokenRequest((b) => b..token = token));
    } on Exception catch (e) {
      debugPrint('Error during upserting FCM token: $e');
      rethrow;
    }
  }
}
