# openapi.api.UsersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usersV1Detail**](UsersApi.md#usersv1detail) | **GET** /v1/users | 
[**usersV1Upsert**](UsersApi.md#usersv1upsert) | **POST** /v1/users | 


# **usersV1Detail**
> UsersV1Detail200Response usersV1Detail()



ユーザーを取得する

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();

try {
    final response = api.usersV1Detail();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersV1Detail: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UsersV1Detail200Response**](UsersV1Detail200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersV1Upsert**
> UsersV1Detail200Response usersV1Upsert(userInfo)



ユーザーを作成または更新する

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final UserInfo userInfo = ; // UserInfo | 作成または更新するユーザーの情報

try {
    final response = api.usersV1Upsert(userInfo);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersV1Upsert: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userInfo** | [**UserInfo**](UserInfo.md)| 作成または更新するユーザーの情報 | 

### Return type

[**UsersV1Detail200Response**](UsersV1Detail200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

