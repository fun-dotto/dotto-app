import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final roomChangeRepositoryProvider = Provider<RoomChangeRepository>(RoomChangeRepositoryImpl.new);

abstract class RoomChangeRepository {
  Future<BuiltList<RoomChange>> getRoomChanges({BuiltList<String>? subjectIds});
}

final class RoomChangeRepositoryImpl implements RoomChangeRepository {
  RoomChangeRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<BuiltList<RoomChange>> getRoomChanges({BuiltList<String>? subjectIds}) async {
    try {
      final api = ref.read(apiClientProvider).getRoomChangesApi();
      final response = await api.roomChangesV1List(from: Date.now(), subjectIds: subjectIds);
      if (response.statusCode != 200) {
        throw DomainError(type: DomainErrorType.invalidResponse, message: 'Failed to get room changes');
      }
      final data = response.data;
      if (data == null) {
        throw DomainError(type: DomainErrorType.invalidResponse, message: 'Failed to get room changes');
      }
      return data.roomChanges;
    } on DomainError {
      rethrow;
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
      throw DomainError.fromException(e: e, stackTrace: stackTrace);
    }
  }
}
