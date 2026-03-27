//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'academic_service_faculty.g.dart';

/// AcademicServiceFaculty
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [email] 
@BuiltValue()
abstract class AcademicServiceFaculty implements Built<AcademicServiceFaculty, AcademicServiceFacultyBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  AcademicServiceFaculty._();

  factory AcademicServiceFaculty([void updates(AcademicServiceFacultyBuilder b)]) = _$AcademicServiceFaculty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AcademicServiceFacultyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AcademicServiceFaculty> get serializer => _$AcademicServiceFacultySerializer();
}

class _$AcademicServiceFacultySerializer implements PrimitiveSerializer<AcademicServiceFaculty> {
  @override
  final Iterable<Type> types = const [AcademicServiceFaculty, _$AcademicServiceFaculty];

  @override
  final String wireName = r'AcademicServiceFaculty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AcademicServiceFaculty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AcademicServiceFaculty object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AcademicServiceFacultyBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AcademicServiceFaculty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AcademicServiceFacultyBuilder();
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

