//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/faculty_service_faculty.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subject_service_subject_faculty.g.dart';

/// SubjectServiceSubjectFaculty
///
/// Properties:
/// * [faculty] 
/// * [isPrimary] 
@BuiltValue()
abstract class SubjectServiceSubjectFaculty implements Built<SubjectServiceSubjectFaculty, SubjectServiceSubjectFacultyBuilder> {
  @BuiltValueField(wireName: r'faculty')
  FacultyServiceFaculty get faculty;

  @BuiltValueField(wireName: r'isPrimary')
  bool get isPrimary;

  SubjectServiceSubjectFaculty._();

  factory SubjectServiceSubjectFaculty([void updates(SubjectServiceSubjectFacultyBuilder b)]) = _$SubjectServiceSubjectFaculty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubjectServiceSubjectFacultyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectServiceSubjectFaculty> get serializer => _$SubjectServiceSubjectFacultySerializer();
}

class _$SubjectServiceSubjectFacultySerializer implements PrimitiveSerializer<SubjectServiceSubjectFaculty> {
  @override
  final Iterable<Type> types = const [SubjectServiceSubjectFaculty, _$SubjectServiceSubjectFaculty];

  @override
  final String wireName = r'SubjectServiceSubjectFaculty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectServiceSubjectFaculty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'faculty';
    yield serializers.serialize(
      object.faculty,
      specifiedType: const FullType(FacultyServiceFaculty),
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
    SubjectServiceSubjectFaculty object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectServiceSubjectFacultyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'faculty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FacultyServiceFaculty),
          ) as FacultyServiceFaculty;
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
  SubjectServiceSubjectFaculty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectServiceSubjectFacultyBuilder();
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

