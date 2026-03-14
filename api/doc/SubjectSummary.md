# openapi.model.SubjectSummary

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**name** | **String** |  | 
**faculties** | [**BuiltList&lt;SubjectFaculty&gt;**](SubjectFaculty.md) |  | 
**dayOfWeek** | [**DottoFoundationV1DayOfWeek**](DottoFoundationV1DayOfWeek.md) | TODO: Timetable API から曜日を取得する 曜日 | 
**period** | [**DottoFoundationV1Period**](DottoFoundationV1Period.md) | TODO: Timetable API から時限を取得する 時限 | 
**isAddedToTimetable** | **bool** | TODO: 時間割APIを作成したら、時間割に追加されているかを取得する 時間割に追加されているか | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


