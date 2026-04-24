import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ReservationsApi
void main() {
  final instance = Openapi().getReservationsApi();

  group(ReservationsApi, () {
    // 教室の予約一覧を取得する 検索対象期間に一部でも重複する予約が取得される
    //
    //Future<ReservationsV1List200Response> reservationsV1List({ BuiltList<String> roomIds, DateTime from, DateTime until }) async
    test('test reservationsV1List', () async {
      // TODO
    });

  });
}
