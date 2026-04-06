import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final cancelledClassRepositoryProvider = Provider<CancelledClassRepository>(CancelledClassRepositoryImpl.new);

abstract class CancelledClassRepository {
  Future<BuiltList<CancelledClass>> getCancelledClasses({BuiltList<String>? subjectIds});
}

final class CancelledClassRepositoryImpl implements CancelledClassRepository {
  CancelledClassRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<BuiltList<CancelledClass>> getCancelledClasses({BuiltList<String>? subjectIds}) async {
    try {
      final api = ref.read(apiClientProvider).getCancelledClassesApi();
      final response = await api.cancelledClassesV1List(from: Date.now(), subjectIds: subjectIds);
      if (response.statusCode != 200) {
        throw Exception('Failed to get cancelled classes');
      }
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to get cancelled classes');
      }
      return data.cancelledClasses;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
