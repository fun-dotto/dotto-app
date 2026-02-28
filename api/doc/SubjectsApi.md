# openapi.api.SubjectsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**subjectsV1Detail**](SubjectsApi.md#subjectsv1detail) | **GET** /v1/subjects/{id} | 
[**subjectsV1List**](SubjectsApi.md#subjectsv1list) | **GET** /v1/subjects | 


# **subjectsV1Detail**
> SubjectsV1Detail200Response subjectsV1Detail(id)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubjectsApi();
final String id = id_example; // String | 

try {
    final response = api.subjectsV1Detail(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubjectsApi->subjectsV1Detail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**SubjectsV1Detail200Response**](SubjectsV1Detail200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subjectsV1List**
> SubjectsV1List200Response subjectsV1List(q, grade, courses, class_, classification, semester, requirementType, calturalSubjectCategory)



科目を検索する  同一項目同士はOR、異なる項目同士はANDでフィルタリングされます。

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubjectsApi();
final String q = q_example; // String | 検索ワード
final BuiltList<DottoFoundationV1Grade> grade = ; // BuiltList<DottoFoundationV1Grade> | 学年
final BuiltList<DottoFoundationV1Course> courses = ; // BuiltList<DottoFoundationV1Course> | コース; 大学院の場合は大学院コースに読み替え
final BuiltList<DottoFoundationV1Class> class_ = ; // BuiltList<DottoFoundationV1Class> | クラス; 大学院の学年を選択した場合は選択できない
final BuiltList<DottoFoundationV1SubjectClassification> classification = ; // BuiltList<DottoFoundationV1SubjectClassification> | 学部: 専門・教養; 大学院: 専門・研究指導
final BuiltList<DottoFoundationV1CourseSemester> semester = ; // BuiltList<DottoFoundationV1CourseSemester> | 開講時期
final BuiltList<DottoFoundationV1SubjectRequirementType> requirementType = ; // BuiltList<DottoFoundationV1SubjectRequirementType> | 必修・選択・選択必修
final BuiltList<DottoFoundationV1CulturalSubjectCategory> calturalSubjectCategory = ; // BuiltList<DottoFoundationV1CulturalSubjectCategory> | 教養科目カテゴリ

try {
    final response = api.subjectsV1List(q, grade, courses, class_, classification, semester, requirementType, calturalSubjectCategory);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SubjectsApi->subjectsV1List: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| 検索ワード | 
 **grade** | [**BuiltList&lt;DottoFoundationV1Grade&gt;**](DottoFoundationV1Grade.md)| 学年 | 
 **courses** | [**BuiltList&lt;DottoFoundationV1Course&gt;**](DottoFoundationV1Course.md)| コース; 大学院の場合は大学院コースに読み替え | 
 **class_** | [**BuiltList&lt;DottoFoundationV1Class&gt;**](DottoFoundationV1Class.md)| クラス; 大学院の学年を選択した場合は選択できない | 
 **classification** | [**BuiltList&lt;DottoFoundationV1SubjectClassification&gt;**](DottoFoundationV1SubjectClassification.md)| 学部: 専門・教養; 大学院: 専門・研究指導 | 
 **semester** | [**BuiltList&lt;DottoFoundationV1CourseSemester&gt;**](DottoFoundationV1CourseSemester.md)| 開講時期 | 
 **requirementType** | [**BuiltList&lt;DottoFoundationV1SubjectRequirementType&gt;**](DottoFoundationV1SubjectRequirementType.md)| 必修・選択・選択必修 | 
 **calturalSubjectCategory** | [**BuiltList&lt;DottoFoundationV1CulturalSubjectCategory&gt;**](DottoFoundationV1CulturalSubjectCategory.md)| 教養科目カテゴリ | 

### Return type

[**SubjectsV1List200Response**](SubjectsV1List200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

