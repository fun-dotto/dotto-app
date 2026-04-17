# openapi.api.MenuItemsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**menuItemsV1List**](MenuItemsApi.md#menuitemsv1list) | **GET** /v1/menuItems | 


# **menuItemsV1List**
> MenuItemsV1List200Response menuItemsV1List(date)



メニューを取得する

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: FirebaseAppCheckAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKeyPrefix = 'Bearer';

final api = Openapi().getMenuItemsApi();
final Date date = 2013-10-20; // Date | メニューを取得する日付

try {
    final response = api.menuItemsV1List(date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MenuItemsApi->menuItemsV1List: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **Date**| メニューを取得する日付 | 

### Return type

[**MenuItemsV1List200Response**](MenuItemsV1List200Response.md)

### Authorization

[FirebaseAppCheckAuth](../README.md#FirebaseAppCheckAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

