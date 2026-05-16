import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UsersApi
void main() {
  final instance = Openapi().getUsersApi();

  group(UsersApi, () {
    // ユーザーを取得する
    //
    //Future<UsersV1Detail200Response> usersV1Detail(String id) async
    test('test usersV1Detail', () async {
      // TODO
    });

    // ユーザーを作成または更新する
    //
    //Future<UsersV1Detail200Response> usersV1Upsert(String id, UserInfo userInfo) async
    test('test usersV1Upsert', () async {
      // TODO
    });

  });
}
