import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for MenuItemsApi
void main() {
  final instance = Openapi().getMenuItemsApi();

  group(MenuItemsApi, () {
    // メニューを取得する
    //
    //Future<MenuItemsV1List200Response> menuItemsV1List(Date date) async
    test('test menuItemsV1List', () async {
      // TODO
    });

  });
}
