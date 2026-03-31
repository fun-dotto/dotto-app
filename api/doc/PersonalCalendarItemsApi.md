# openapi.api.PersonalCalendarItemsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**personalCalendarItemsV1List**](PersonalCalendarItemsApi.md#personalcalendaritemsv1list) | **GET** /v1/personalCalendarItems | 


# **personalCalendarItemsV1List**
> PersonalCalendarItemsV1List200Response personalCalendarItemsV1List(dates)



個人カレンダーアイテム一覧を取得する

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: FirebaseAppCheckAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKeyPrefix = 'Bearer';

final api = Openapi().getPersonalCalendarItemsApi();
final BuiltList<DateTime> dates = ; // BuiltList<DateTime> | 日付のリスト; 指定した日付の個人カレンダーアイテムのみを取得する

try {
    final response = api.personalCalendarItemsV1List(dates);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PersonalCalendarItemsApi->personalCalendarItemsV1List: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dates** | [**BuiltList&lt;DateTime&gt;**](DateTime.md)| 日付のリスト; 指定した日付の個人カレンダーアイテムのみを取得する | 

### Return type

[**PersonalCalendarItemsV1List200Response**](PersonalCalendarItemsV1List200Response.md)

### Authorization

[FirebaseAppCheckAuth](../README.md#FirebaseAppCheckAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

