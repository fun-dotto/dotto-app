import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for CourseRegistrationsApi
void main() {
  final instance = Openapi().getCourseRegistrationsApi();

  group(CourseRegistrationsApi, () {
    // 履修情報を作成する
    //
    //Future<CourseRegistrationsV1Create201Response> courseRegistrationsV1Create(CourseRegistrationRequest courseRegistrationRequest) async
    test('test courseRegistrationsV1Create', () async {
      // TODO
    });

    // 履修情報を削除する
    //
    //Future courseRegistrationsV1Delete(String id) async
    test('test courseRegistrationsV1Delete', () async {
      // TODO
    });

    // 履修情報を取得する
    //
    //Future<CourseRegistrationsV1List200Response> courseRegistrationsV1List(DottoFoundationV1CourseSemester semester, { int year }) async
    test('test courseRegistrationsV1List', () async {
      // TODO
    });

  });
}
