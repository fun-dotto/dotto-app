//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/course_registration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'course_registrations_v1_create201_response.g.dart';

/// CourseRegistrationsV1Create201Response
///
/// Properties:
/// * [courseRegistration] 
@BuiltValue()
abstract class CourseRegistrationsV1Create201Response implements Built<CourseRegistrationsV1Create201Response, CourseRegistrationsV1Create201ResponseBuilder> {
  @BuiltValueField(wireName: r'courseRegistration')
  CourseRegistration get courseRegistration;

  CourseRegistrationsV1Create201Response._();

  factory CourseRegistrationsV1Create201Response([void updates(CourseRegistrationsV1Create201ResponseBuilder b)]) = _$CourseRegistrationsV1Create201Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CourseRegistrationsV1Create201ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CourseRegistrationsV1Create201Response> get serializer => _$CourseRegistrationsV1Create201ResponseSerializer();
}

class _$CourseRegistrationsV1Create201ResponseSerializer implements PrimitiveSerializer<CourseRegistrationsV1Create201Response> {
  @override
  final Iterable<Type> types = const [CourseRegistrationsV1Create201Response, _$CourseRegistrationsV1Create201Response];

  @override
  final String wireName = r'CourseRegistrationsV1Create201Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CourseRegistrationsV1Create201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'courseRegistration';
    yield serializers.serialize(
      object.courseRegistration,
      specifiedType: const FullType(CourseRegistration),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CourseRegistrationsV1Create201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CourseRegistrationsV1Create201ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'courseRegistration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CourseRegistration),
          ) as CourseRegistration;
          result.courseRegistration.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CourseRegistrationsV1Create201Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CourseRegistrationsV1Create201ResponseBuilder();
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

