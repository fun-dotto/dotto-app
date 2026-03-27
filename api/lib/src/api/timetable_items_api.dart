//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/api_util.dart';
import 'package:openapi/src/model/dotto_foundation_v1_course_semester.dart';
import 'package:openapi/src/model/timetable_items_v1_list200_response.dart';

class TimetableItemsApi {

  final Dio _dio;

  final Serializers _serializers;

  const TimetableItemsApi(this._dio, this._serializers);

  /// timetableItemsV1List
  /// 時間割を取得する
  ///
  /// Parameters:
  /// * [semesters] - 開講時期
  /// * [year] - 開講年度; 指定しない場合は今年度が選択される
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [TimetableItemsV1List200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<TimetableItemsV1List200Response>> timetableItemsV1List({ 
    required BuiltList<DottoFoundationV1CourseSemester> semesters,
    int? year,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/timetableItems';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'Bearer',
            'name': 'BearerAuth',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (year != null) r'year': encodeQueryParameter(_serializers, year, const FullType(int)),
      r'semesters': encodeCollectionQueryParameter<DottoFoundationV1CourseSemester>(_serializers, semesters, const FullType(BuiltList, [FullType(DottoFoundationV1CourseSemester)]), format: ListFormat.csv,),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    TimetableItemsV1List200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(TimetableItemsV1List200Response),
      ) as TimetableItemsV1List200Response;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<TimetableItemsV1List200Response>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
