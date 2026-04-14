# openapi.api.RoomChangesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**roomChangesV1List**](RoomChangesApi.md#roomchangesv1list) | **GET** /v1/roomChanges | 


# **roomChangesV1List**
> RoomChangesV1List200Response roomChangesV1List(subjectIds, from, until)



教室変更一覧を取得する

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: FirebaseAppCheckAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKeyPrefix = 'Bearer';

final api = Openapi().getRoomChangesApi();
final BuiltList<String> subjectIds = ; // BuiltList<String> | 科目IDのリスト; 指定した科目の教室変更のみを取得する; 指定しない場合は全科目を検索対象とする
final Date from = 2013-10-20; // Date | 検索対象開始日付
final Date until = 2013-10-20; // Date | 検索対象終了日付

try {
    final response = api.roomChangesV1List(subjectIds, from, until);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RoomChangesApi->roomChangesV1List: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subjectIds** | [**BuiltList&lt;String&gt;**](String.md)| 科目IDのリスト; 指定した科目の教室変更のみを取得する; 指定しない場合は全科目を検索対象とする | [optional] 
 **from** | **Date**| 検索対象開始日付 | [optional] 
 **until** | **Date**| 検索対象終了日付 | [optional] 

### Return type

[**RoomChangesV1List200Response**](RoomChangesV1List200Response.md)

### Authorization

[FirebaseAppCheckAuth](../README.md#FirebaseAppCheckAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

