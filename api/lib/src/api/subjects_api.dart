//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/api_util.dart';
import 'package:openapi/src/model/dotto_foundation_v1_class.dart';
import 'package:openapi/src/model/dotto_foundation_v1_course.dart';
import 'package:openapi/src/model/dotto_foundation_v1_course_semester.dart';
import 'package:openapi/src/model/dotto_foundation_v1_cultural_subject_category.dart';
import 'package:openapi/src/model/dotto_foundation_v1_grade.dart';
import 'package:openapi/src/model/dotto_foundation_v1_subject_classification.dart';
import 'package:openapi/src/model/dotto_foundation_v1_subject_requirement_type.dart';
import 'package:openapi/src/model/subjects_v1_detail200_response.dart';
import 'package:openapi/src/model/subjects_v1_list200_response.dart';

class SubjectsApi {

  final Dio _dio;

  final Serializers _serializers;

  const SubjectsApi(this._dio, this._serializers);

  /// subjectsV1Detail
  /// 
  ///
  /// Parameters:
  /// * [id] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SubjectsV1Detail200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SubjectsV1Detail200Response>> subjectsV1Detail({ 
    required String id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/subjects/{id}'.replaceAll('{' r'id' '}', encodeQueryParameter(_serializers, id, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SubjectsV1Detail200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SubjectsV1Detail200Response),
      ) as SubjectsV1Detail200Response;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SubjectsV1Detail200Response>(
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

  /// subjectsV1List
  /// 科目を検索する  同一項目同士はOR、異なる項目同士はANDでフィルタリングされます。
  ///
  /// Parameters:
  /// * [q] - 検索ワード
  /// * [grade] - 学年
  /// * [courses] - コース; 大学院の場合は大学院コースに読み替え
  /// * [class_] - クラス; 大学院の学年を選択した場合は選択できない
  /// * [classification] - 学部: 専門・教養; 大学院: 専門・研究指導
  /// * [semester] - 開講時期
  /// * [requirementType] - 必修・選択・選択必修
  /// * [culturalSubjectCategory] - 教養科目カテゴリ
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SubjectsV1List200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SubjectsV1List200Response>> subjectsV1List({ 
    required String q,
    required BuiltList<DottoFoundationV1Grade> grade,
    required BuiltList<DottoFoundationV1Course> courses,
    required BuiltList<DottoFoundationV1Class> class_,
    required BuiltList<DottoFoundationV1SubjectClassification> classification,
    required BuiltList<DottoFoundationV1CourseSemester> semester,
    required BuiltList<DottoFoundationV1SubjectRequirementType> requirementType,
    required BuiltList<DottoFoundationV1CulturalSubjectCategory> culturalSubjectCategory,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/subjects';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'q': encodeQueryParameter(_serializers, q, const FullType(String)),
      r'grade': encodeCollectionQueryParameter<DottoFoundationV1Grade>(_serializers, grade, const FullType(BuiltList, [FullType(DottoFoundationV1Grade)]), format: ListFormat.csv,),
      r'courses': encodeCollectionQueryParameter<DottoFoundationV1Course>(_serializers, courses, const FullType(BuiltList, [FullType(DottoFoundationV1Course)]), format: ListFormat.csv,),
      r'class': encodeCollectionQueryParameter<DottoFoundationV1Class>(_serializers, class_, const FullType(BuiltList, [FullType(DottoFoundationV1Class)]), format: ListFormat.csv,),
      r'classification': encodeCollectionQueryParameter<DottoFoundationV1SubjectClassification>(_serializers, classification, const FullType(BuiltList, [FullType(DottoFoundationV1SubjectClassification)]), format: ListFormat.csv,),
      r'semester': encodeCollectionQueryParameter<DottoFoundationV1CourseSemester>(_serializers, semester, const FullType(BuiltList, [FullType(DottoFoundationV1CourseSemester)]), format: ListFormat.csv,),
      r'requirementType': encodeCollectionQueryParameter<DottoFoundationV1SubjectRequirementType>(_serializers, requirementType, const FullType(BuiltList, [FullType(DottoFoundationV1SubjectRequirementType)]), format: ListFormat.csv,),
      r'culturalSubjectCategory': encodeCollectionQueryParameter<DottoFoundationV1CulturalSubjectCategory>(_serializers, culturalSubjectCategory, const FullType(BuiltList, [FullType(DottoFoundationV1CulturalSubjectCategory)]), format: ListFormat.csv,),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SubjectsV1List200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SubjectsV1List200Response),
      ) as SubjectsV1List200Response;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SubjectsV1List200Response>(
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
