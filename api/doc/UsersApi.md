# openapi.api.UsersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usersV1Detail**](UsersApi.md#usersv1detail) | **GET** /v1/users/{id} | 
[**usersV1Upsert**](UsersApi.md#usersv1upsert) | **POST** /v1/users/{id} | 


# **usersV1Detail**
> UsersV1Detail200Response usersV1Detail(id)



ユーザーを取得する

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String id = id_example; // String | ユーザーID

try {
    final response = api.usersV1Detail(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersV1Detail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| ユーザーID | 

### Return type

[**UsersV1Detail200Response**](UsersV1Detail200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersV1Upsert**
> UsersV1Detail200Response usersV1Upsert(id, userInfo)



ユーザーを作成または更新する

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String id = id_example; // String | 
final UserInfo userInfo = ; // UserInfo | 作成または更新するユーザーの情報

try {
    final response = api.usersV1Upsert(id, userInfo);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->usersV1Upsert: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **userInfo** | [**UserInfo**](UserInfo.md)| 作成または更新するユーザーの情報 | 

### Return type

[**UsersV1Detail200Response**](UsersV1Detail200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

