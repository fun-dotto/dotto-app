import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final makeupClassRepositoryProvider = Provider<MakeupClassRepository>(MakeupClassRepositoryImpl.new);

abstract class MakeupClassRepository {
  Future<BuiltList<MakeupClass>> getMakeupClasses({BuiltList<String>? subjectIds});
}

final class MakeupClassRepositoryImpl implements MakeupClassRepository {
  MakeupClassRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<BuiltList<MakeupClass>> getMakeupClasses({BuiltList<String>? subjectIds}) async {
    try {
      final api = ref.read(apiClientProvider).getMakeupClassesApi();
      final response = await api.makeupClassesV1List(from: Date.now(), subjectIds: subjectIds);
      if (response.statusCode != 200) {
        throw Exception('Failed to get makeup classes');
      }
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to get makeup classes');
      }
      return data.makeupClasses;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
