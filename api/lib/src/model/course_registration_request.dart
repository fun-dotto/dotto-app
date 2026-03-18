//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'course_registration_request.g.dart';

/// CourseRegistrationRequest
///
/// Properties:
/// * [subjectId] 
@BuiltValue()
abstract class CourseRegistrationRequest implements Built<CourseRegistrationRequest, CourseRegistrationRequestBuilder> {
  @BuiltValueField(wireName: r'subjectId')
  String get subjectId;

  CourseRegistrationRequest._();

  factory CourseRegistrationRequest([void updates(CourseRegistrationRequestBuilder b)]) = _$CourseRegistrationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CourseRegistrationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CourseRegistrationRequest> get serializer => _$CourseRegistrationRequestSerializer();
}

class _$CourseRegistrationRequestSerializer implements PrimitiveSerializer<CourseRegistrationRequest> {
  @override
  final Iterable<Type> types = const [CourseRegistrationRequest, _$CourseRegistrationRequest];

  @override
  final String wireName = r'CourseRegistrationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CourseRegistrationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subjectId';
    yield serializers.serialize(
      object.subjectId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CourseRegistrationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CourseRegistrationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subjectId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CourseRegistrationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CourseRegistrationRequestBuilder();
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

