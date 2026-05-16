//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/subject_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'course_registration.g.dart';

/// CourseRegistration
///
/// Properties:
/// * [id] 
/// * [subject] 
@BuiltValue()
abstract class CourseRegistration implements Built<CourseRegistration, CourseRegistrationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subject')
  SubjectSummary get subject;

  CourseRegistration._();

  factory CourseRegistration([void updates(CourseRegistrationBuilder b)]) = _$CourseRegistration;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CourseRegistrationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CourseRegistration> get serializer => _$CourseRegistrationSerializer();
}

class _$CourseRegistrationSerializer implements PrimitiveSerializer<CourseRegistration> {
  @override
  final Iterable<Type> types = const [CourseRegistration, _$CourseRegistration];

  @override
  final String wireName = r'CourseRegistration';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CourseRegistration object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(SubjectSummary),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CourseRegistration object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CourseRegistrationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubjectSummary),
          ) as SubjectSummary;
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
  CourseRegistration deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CourseRegistrationBuilder();
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

