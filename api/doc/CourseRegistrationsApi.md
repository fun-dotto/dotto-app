# openapi.api.CourseRegistrationsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**courseRegistrationsV1Create**](CourseRegistrationsApi.md#courseregistrationsv1create) | **POST** /v1/courseRegistrations | 
[**courseRegistrationsV1Delete**](CourseRegistrationsApi.md#courseregistrationsv1delete) | **DELETE** /v1/courseRegistrations/{id} | 
[**courseRegistrationsV1List**](CourseRegistrationsApi.md#courseregistrationsv1list) | **GET** /v1/courseRegistrations | 


# **courseRegistrationsV1Create**
> CourseRegistrationsV1Create201Response courseRegistrationsV1Create(courseRegistrationRequest)



履修情報を作成する

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCourseRegistrationsApi();
final CourseRegistrationRequest courseRegistrationRequest = ; // CourseRegistrationRequest | 作成する履修情報の情報

try {
    final response = api.courseRegistrationsV1Create(courseRegistrationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CourseRegistrationsApi->courseRegistrationsV1Create: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **courseRegistrationRequest** | [**CourseRegistrationRequest**](CourseRegistrationRequest.md)| 作成する履修情報の情報 | 

### Return type

[**CourseRegistrationsV1Create201Response**](CourseRegistrationsV1Create201Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **courseRegistrationsV1Delete**
> courseRegistrationsV1Delete(id)



履修情報を削除する

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCourseRegistrationsApi();
final String id = id_example; // String | 履修情報ID

try {
    api.courseRegistrationsV1Delete(id);
} on DioException catch (e) {
    print('Exception when calling CourseRegistrationsApi->courseRegistrationsV1Delete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| 履修情報ID | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **courseRegistrationsV1List**
> CourseRegistrationsV1List200Response courseRegistrationsV1List(semester, year)



履修情報を取得する

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCourseRegistrationsApi();
final DottoFoundationV1CourseSemester semester = ; // DottoFoundationV1CourseSemester | 開講時期
final int year = 56; // int | 開講年度; 指定しない場合は今年度が選択される

try {
    final response = api.courseRegistrationsV1List(semester, year);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CourseRegistrationsApi->courseRegistrationsV1List: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **semester** | [**DottoFoundationV1CourseSemester**](.md)| 開講時期 | 
 **year** | **int**| 開講年度; 指定しない場合は今年度が選択される | [optional] 

### Return type

[**CourseRegistrationsV1List200Response**](CourseRegistrationsV1List200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

