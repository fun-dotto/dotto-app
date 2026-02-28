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
**faculties** | [**BuiltList&lt;SubjectServiceSubjectFaculty&gt;**](SubjectServiceSubjectFaculty.md) |  | 
**semester** | [**DottoFoundationV1CourseSemester**](DottoFoundationV1CourseSemester.md) |  | 
**credit** | **int** | 単位数 | 
**eligibleAttributes** | [**BuiltList&lt;SubjectServiceSubjectTargetClass&gt;**](SubjectServiceSubjectTargetClass.md) | 授業名末尾の`学年-クラス`をもとに決定 | 
**requirements** | [**BuiltList&lt;SubjectServiceSubjectRequirement&gt;**](SubjectServiceSubjectRequirement.md) | 科目群・科目区分をもとに決定 | 
**syllabus** | [**SubjectServiceSyllabus**](SubjectServiceSyllabus.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


