# openapi.api.TimetableItemsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**timetableItemsV1List**](TimetableItemsApi.md#timetableitemsv1list) | **GET** /v1/timetableItems | 


# **timetableItemsV1List**
> TimetableItemsV1List200Response timetableItemsV1List(semesters, year)



時間割を取得する

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getTimetableItemsApi();
final BuiltList<DottoFoundationV1CourseSemester> semesters = ; // BuiltList<DottoFoundationV1CourseSemester> | 開講時期
final int year = 56; // int | 開講年度; 指定しない場合は今年度が選択される

try {
    final response = api.timetableItemsV1List(semesters, year);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TimetableItemsApi->timetableItemsV1List: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **semesters** | [**BuiltList&lt;DottoFoundationV1CourseSemester&gt;**](DottoFoundationV1CourseSemester.md)| 開講時期 | 
 **year** | **int**| 開講年度; 指定しない場合は今年度が選択される | [optional] 

### Return type

[**TimetableItemsV1List200Response**](TimetableItemsV1List200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

