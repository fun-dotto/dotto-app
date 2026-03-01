//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'faculty_service_faculty.g.dart';

/// 教員
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [email] 
@BuiltValue()
abstract class FacultyServiceFaculty implements Built<FacultyServiceFaculty, FacultyServiceFacultyBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  FacultyServiceFaculty._();

  factory FacultyServiceFaculty([void updates(FacultyServiceFacultyBuilder b)]) = _$FacultyServiceFaculty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FacultyServiceFacultyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FacultyServiceFaculty> get serializer => _$FacultyServiceFacultySerializer();
}

class _$FacultyServiceFacultySerializer implements PrimitiveSerializer<FacultyServiceFaculty> {
  @override
  final Iterable<Type> types = const [FacultyServiceFaculty, _$FacultyServiceFaculty];

  @override
  final String wireName = r'FacultyServiceFaculty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FacultyServiceFaculty object, {
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
    FacultyServiceFaculty object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FacultyServiceFacultyBuilder result,
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
  FacultyServiceFaculty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FacultyServiceFacultyBuilder();
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

