# openapi.api.ReservationsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reservationsV1List**](ReservationsApi.md#reservationsv1list) | **GET** /v1/reservations | 


# **reservationsV1List**
> ReservationsV1List200Response reservationsV1List(roomIds, from, until)



教室の予約一覧を取得する 検索対象期間に一部でも重複する予約が取得される

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: FirebaseAppCheckAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKeyPrefix = 'Bearer';

final api = Openapi().getReservationsApi();
final BuiltList<String> roomIds = ; // BuiltList<String> | 教室IDのリスト
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 検索対象開始日時
final DateTime until = 2013-10-20T19:20:30+01:00; // DateTime | 検索対象終了日時

try {
    final response = api.reservationsV1List(roomIds, from, until);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReservationsApi->reservationsV1List: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roomIds** | [**BuiltList&lt;String&gt;**](String.md)| 教室IDのリスト | [optional] 
 **from** | **DateTime**| 検索対象開始日時 | [optional] 
 **until** | **DateTime**| 検索対象終了日時 | [optional] 

### Return type

[**ReservationsV1List200Response**](ReservationsV1List200Response.md)

### Authorization

[FirebaseAppCheckAuth](../README.md#FirebaseAppCheckAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

