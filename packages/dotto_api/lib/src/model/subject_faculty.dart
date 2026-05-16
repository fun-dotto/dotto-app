//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/academic_service_faculty.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subject_faculty.g.dart';

/// SubjectFaculty
///
/// Properties:
/// * [faculty] 
/// * [isPrimary] 
@BuiltValue()
abstract class SubjectFaculty implements Built<SubjectFaculty, SubjectFacultyBuilder> {
  @BuiltValueField(wireName: r'faculty')
  AcademicServiceFaculty get faculty;

  @BuiltValueField(wireName: r'isPrimary')
  bool get isPrimary;

  SubjectFaculty._();

  factory SubjectFaculty([void updates(SubjectFacultyBuilder b)]) = _$SubjectFaculty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubjectFacultyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectFaculty> get serializer => _$SubjectFacultySerializer();
}

class _$SubjectFacultySerializer implements PrimitiveSerializer<SubjectFaculty> {
  @override
  final Iterable<Type> types = const [SubjectFaculty, _$SubjectFaculty];

  @override
  final String wireName = r'SubjectFaculty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectFaculty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'faculty';
    yield serializers.serialize(
      object.faculty,
      specifiedType: const FullType(AcademicServiceFaculty),
    );
    yield r'isPrimary';
    yield serializers.serialize(
      object.isPrimary,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubjectFaculty object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectFacultyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'faculty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AcademicServiceFaculty),
          ) as AcademicServiceFaculty;
          result.faculty.replace(valueDes);
          break;
        case r'isPrimary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPrimary = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubjectFaculty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectFacultyBuilder();
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

