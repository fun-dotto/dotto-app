import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for TimetableItemsApi
void main() {
  final instance = Openapi().getTimetableItemsApi();

  group(TimetableItemsApi, () {
    // 時間割を取得する
    //
    //Future<TimetableItemsV1List200Response> timetableItemsV1List(DottoFoundationV1CourseSemester semester, { int year, BuiltList<DottoFoundationV1DayOfWeek> dayOfWeek }) async
    test('test timetableItemsV1List', () async {
      // TODO
    });

  });
}
