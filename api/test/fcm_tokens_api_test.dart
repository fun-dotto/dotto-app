import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for FCMTokensApi
void main() {
  final instance = Openapi().getFCMTokensApi();

  group(FCMTokensApi, () {
    // FCMトークンを作成または更新する 存在しない場合は作成し、存在する場合は更新日時を更新する
    //
    //Future<FCMTokenV1Upsert200Response> fCMTokenV1Upsert(FCMTokenRequest fCMTokenRequest) async
    test('test fCMTokenV1Upsert', () async {
      // TODO
    });

  });
}
