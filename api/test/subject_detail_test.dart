import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

// tests for SubjectDetail
void main() {
  final instance = SubjectDetailBuilder();
  // TODO add properties to the builder and call build()

  group(SubjectDetail, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // BuiltList<SubjectServiceSubjectFaculty> faculties
    test('to test the property `faculties`', () async {
      // TODO
    });

    // DottoFoundationV1CourseSemester semester
    test('to test the property `semester`', () async {
      // TODO
    });

    // 単位数
    // int credit
    test('to test the property `credit`', () async {
      // TODO
    });

    // 授業名末尾の`学年-クラス`をもとに決定
    // BuiltList<SubjectServiceSubjectTargetClass> eligibleAttributes
    test('to test the property `eligibleAttributes`', () async {
      // TODO
    });

    // 科目群・科目区分をもとに決定
    // BuiltList<SubjectServiceSubjectRequirement> requirements
    test('to test the property `requirements`', () async {
      // TODO
    });

    // SubjectServiceSyllabus syllabus
    test('to test the property `syllabus`', () async {
      // TODO
    });

  });
}
