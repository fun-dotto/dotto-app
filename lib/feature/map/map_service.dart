import 'package:dotto/domain/room.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MapService {
  MapService(this.ref);

  final Ref ref;

  Future<List<Room>> getRooms() async {
    return ref.read(roomRepositoryProvider).getRooms();
  }
}
