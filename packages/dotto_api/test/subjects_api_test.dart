import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SubjectsApi
void main() {
  final instance = Openapi().getSubjectsApi();

  group(SubjectsApi, () {
    //Future<SubjectsV1Detail200Response> subjectsV1Detail(String id) async
    test('test subjectsV1Detail', () async {
      // TODO
    });

    // 科目を検索する  同一項目同士はOR、異なる項目同士はANDでフィルタリングされます。
    //
    //Future<SubjectsV1List200Response> subjectsV1List(String q, BuiltList<DottoFoundationV1Grade> grade, BuiltList<DottoFoundationV1Course> courses, BuiltList<DottoFoundationV1Class> class_, BuiltList<DottoFoundationV1SubjectClassification> classification, BuiltList<DottoFoundationV1CourseSemester> semester, BuiltList<DottoFoundationV1SubjectRequirementType> requirementType, BuiltList<DottoFoundationV1CulturalSubjectCategory> calturalSubjectCategory) async
    test('test subjectsV1List', () async {
      // TODO
    });

  });
}
