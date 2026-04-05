# openapi.api.AnnouncementsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**announcementsV1List**](AnnouncementsApi.md#announcementsv1list) | **GET** /v1/announcements | 


# **announcementsV1List**
> AnnouncementsV1List200Response announcementsV1List()



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure API key authorization: FirebaseAppCheckAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('FirebaseAppCheckAuth').apiKeyPrefix = 'Bearer';

final api = Openapi().getAnnouncementsApi();

try {
    final response = api.announcementsV1List();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AnnouncementsApi->announcementsV1List: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AnnouncementsV1List200Response**](AnnouncementsV1List200Response.md)

### Authorization

[FirebaseAppCheckAuth](../README.md#FirebaseAppCheckAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

