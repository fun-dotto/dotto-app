import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for RoomChangesApi
void main() {
  final instance = Openapi().getRoomChangesApi();

  group(RoomChangesApi, () {
    // 教室変更一覧を取得する
    //
    //Future<RoomChangesV1List200Response> roomChangesV1List({ BuiltList<String> subjectIds, Date from, Date until }) async
    test('test roomChangesV1List', () async {
      // TODO
    });

  });
}
