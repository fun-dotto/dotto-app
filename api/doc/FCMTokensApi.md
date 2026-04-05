# openapi.api.FCMTokensApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**fCMTokenV1Upsert**](FCMTokensApi.md#fcmtokenv1upsert) | **POST** /v1/fcmTokens | 


# **fCMTokenV1Upsert**
> FCMTokenV1Upsert200Response fCMTokenV1Upsert(fCMTokenRequest)



FCMトークンを作成または更新する 存在しない場合は作成し、存在する場合は更新日時を更新する

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: FirebaseAppCheckAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKeyPrefix = 'Bearer';

final api = Openapi().getFCMTokensApi();
final FCMTokenRequest fCMTokenRequest = ; // FCMTokenRequest | 作成または更新するFCMトークンの情報

try {
    final response = api.fCMTokenV1Upsert(fCMTokenRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FCMTokensApi->fCMTokenV1Upsert: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fCMTokenRequest** | [**FCMTokenRequest**](FCMTokenRequest.md)| 作成または更新するFCMトークンの情報 | 

### Return type

[**FCMTokenV1Upsert200Response**](FCMTokenV1Upsert200Response.md)

### Authorization

[FirebaseAppCheckAuth](../README.md#FirebaseAppCheckAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

