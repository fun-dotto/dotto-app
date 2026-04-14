//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/api_util.dart';
import 'package:openapi/src/model/date.dart';
import 'package:openapi/src/model/makeup_classes_v1_list200_response.dart';

class MakeupClassesApi {

  final Dio _dio;

  final Serializers _serializers;

  const MakeupClassesApi(this._dio, this._serializers);

  /// makeupClassesV1List
  /// 補講一覧を取得する
  ///
  /// Parameters:
  /// * [subjectIds] - 科目IDのリスト; 指定した科目の補講のみを取得する; 指定しない場合は全科目を検索対象とする
  /// * [from] - 検索対象開始日付
  /// * [until] - 検索対象終了日付
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MakeupClassesV1List200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MakeupClassesV1List200Response>> makeupClassesV1List({ 
    BuiltList<String>? subjectIds,
    Date? from,
    Date? until,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/makeupClasses';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'FirebaseAppCheckAuth',
            'keyName': 'X-Firebase-AppCheck',
            'where': 'header',
          },{
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
      if (subjectIds != null) r'subjectIds': encodeCollectionQueryParameter<String>(_serializers, subjectIds, const FullType(BuiltList, [FullType(String)]), format: ListFormat.csv,),
      if (from != null) r'from': encodeQueryParameter(_serializers, from, const FullType(Date)),
      if (until != null) r'until': encodeQueryParameter(_serializers, until, const FullType(Date)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MakeupClassesV1List200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(MakeupClassesV1List200Response),
      ) as MakeupClassesV1List200Response;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MakeupClassesV1List200Response>(
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
