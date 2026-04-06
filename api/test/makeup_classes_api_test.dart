import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for MakeupClassesApi
void main() {
  final instance = Openapi().getMakeupClassesApi();

  group(MakeupClassesApi, () {
    // 補講一覧を取得する
    //
    //Future<MakeupClassesV1List200Response> makeupClassesV1List({ BuiltList<String> subjectIds, Date from, Date until }) async
    test('test makeupClassesV1List', () async {
      // TODO
    });

  });
}
