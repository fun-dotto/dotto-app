import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for CancelledClassesApi
void main() {
  final instance = Openapi().getCancelledClassesApi();

  group(CancelledClassesApi, () {
    // 休講一覧を取得する
    //
    //Future<CancelledClassesV1List200Response> cancelledClassesV1List({ BuiltList<String> subjectIds, Date from, Date until }) async
    test('test cancelledClassesV1List', () async {
      // TODO
    });

  });
}
