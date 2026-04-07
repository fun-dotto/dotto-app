//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/course_registration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'course_registrations_v1_list200_response.g.dart';

/// CourseRegistrationsV1List200Response
///
/// Properties:
/// * [courseRegistrations] 
@BuiltValue()
abstract class CourseRegistrationsV1List200Response implements Built<CourseRegistrationsV1List200Response, CourseRegistrationsV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'courseRegistrations')
  BuiltList<CourseRegistration> get courseRegistrations;

  CourseRegistrationsV1List200Response._();

  factory CourseRegistrationsV1List200Response([void updates(CourseRegistrationsV1List200ResponseBuilder b)]) = _$CourseRegistrationsV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CourseRegistrationsV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CourseRegistrationsV1List200Response> get serializer => _$CourseRegistrationsV1List200ResponseSerializer();
}

class _$CourseRegistrationsV1List200ResponseSerializer implements PrimitiveSerializer<CourseRegistrationsV1List200Response> {
  @override
  final Iterable<Type> types = const [CourseRegistrationsV1List200Response, _$CourseRegistrationsV1List200Response];

  @override
  final String wireName = r'CourseRegistrationsV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CourseRegistrationsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'courseRegistrations';
    yield serializers.serialize(
      object.courseRegistrations,
      specifiedType: const FullType(BuiltList, [FullType(CourseRegistration)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CourseRegistrationsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CourseRegistrationsV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'courseRegistrations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CourseRegistration)]),
          ) as BuiltList<CourseRegistration>;
          result.courseRegistrations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CourseRegistrationsV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CourseRegistrationsV1List200ResponseBuilder();
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

