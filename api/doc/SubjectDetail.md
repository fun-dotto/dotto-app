# openapi.model.SubjectDetail

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**name** | **String** |  | 
**faculties** | [**BuiltList&lt;SubjectFaculty&gt;**](SubjectFaculty.md) |  | 
**year** | **int** | 開講年度 | 
**semester** | [**DottoFoundationV1CourseSemester**](DottoFoundationV1CourseSemester.md) | 開講時期 | 
**credit** | **int** | 単位数 | 
**eligibleAttributes** | [**BuiltList&lt;AcademicServiceSubjectTargetClass&gt;**](AcademicServiceSubjectTargetClass.md) | 授業名末尾の`学年-クラス`をもとに決定 | 
**requirements** | [**BuiltList&lt;AcademicServiceSubjectRequirement&gt;**](AcademicServiceSubjectRequirement.md) | 科目群・科目区分をもとに決定 | 
**syllabus** | [**AcademicServiceSyllabus**](AcademicServiceSyllabus.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


