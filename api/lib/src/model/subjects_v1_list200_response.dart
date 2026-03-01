//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subject_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subjects_v1_list200_response.g.dart';

/// SubjectsV1List200Response
///
/// Properties:
/// * [subjects] 
@BuiltValue()
abstract class SubjectsV1List200Response implements Built<SubjectsV1List200Response, SubjectsV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'subjects')
  BuiltList<SubjectSummary> get subjects;

  SubjectsV1List200Response._();

  factory SubjectsV1List200Response([void updates(SubjectsV1List200ResponseBuilder b)]) = _$SubjectsV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubjectsV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectsV1List200Response> get serializer => _$SubjectsV1List200ResponseSerializer();
}

class _$SubjectsV1List200ResponseSerializer implements PrimitiveSerializer<SubjectsV1List200Response> {
  @override
  final Iterable<Type> types = const [SubjectsV1List200Response, _$SubjectsV1List200Response];

  @override
  final String wireName = r'SubjectsV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subjects';
    yield serializers.serialize(
      object.subjects,
      specifiedType: const FullType(BuiltList, [FullType(SubjectSummary)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubjectsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectsV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subjects':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SubjectSummary)]),
          ) as BuiltList<SubjectSummary>;
          result.subjects.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubjectsV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectsV1List200ResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

