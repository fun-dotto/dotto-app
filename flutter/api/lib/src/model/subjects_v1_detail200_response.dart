//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/subject_detail.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subjects_v1_detail200_response.g.dart';

/// SubjectsV1Detail200Response
///
/// Properties:
/// * [subject] 
@BuiltValue()
abstract class SubjectsV1Detail200Response implements Built<SubjectsV1Detail200Response, SubjectsV1Detail200ResponseBuilder> {
  @BuiltValueField(wireName: r'subject')
  SubjectDetail get subject;

  SubjectsV1Detail200Response._();

  factory SubjectsV1Detail200Response([void updates(SubjectsV1Detail200ResponseBuilder b)]) = _$SubjectsV1Detail200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubjectsV1Detail200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectsV1Detail200Response> get serializer => _$SubjectsV1Detail200ResponseSerializer();
}

class _$SubjectsV1Detail200ResponseSerializer implements PrimitiveSerializer<SubjectsV1Detail200Response> {
  @override
  final Iterable<Type> types = const [SubjectsV1Detail200Response, _$SubjectsV1Detail200Response];

  @override
  final String wireName = r'SubjectsV1Detail200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectsV1Detail200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(SubjectDetail),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubjectsV1Detail200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectsV1Detail200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubjectDetail),
          ) as SubjectDetail;
          result.subject.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubjectsV1Detail200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectsV1Detail200ResponseBuilder();
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

