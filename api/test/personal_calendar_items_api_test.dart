import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for PersonalCalendarItemsApi
void main() {
  final instance = Openapi().getPersonalCalendarItemsApi();

  group(PersonalCalendarItemsApi, () {
    // 個人カレンダーアイテム一覧を取得する
    //
    //Future<PersonalCalendarItemsV1List200Response> personalCalendarItemsV1List(BuiltList<DateTime> dates) async
    test('test personalCalendarItemsV1List', () async {
      // TODO
    });

  });
}
