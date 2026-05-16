//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_course.dart';
import 'package:openapi/src/model/dotto_foundation_v1_subject_requirement_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subject_service_subject_requirement.g.dart';

/// SubjectServiceSubjectRequirement
///
/// Properties:
/// * [course] 
/// * [requirementType] 
@BuiltValue()
abstract class SubjectServiceSubjectRequirement implements Built<SubjectServiceSubjectRequirement, SubjectServiceSubjectRequirementBuilder> {
  @BuiltValueField(wireName: r'course')
  DottoFoundationV1Course get course;
  // enum courseEnum {  InformationSystem,  InformationDesign,  AdvancedICT,  ComplexSystem,  IntelligentSystem,  };

  @BuiltValueField(wireName: r'requirementType')
  DottoFoundationV1SubjectRequirementType get requirementType;
  // enum requirementTypeEnum {  Required,  Optional,  OptionalRequired,  };

  SubjectServiceSubjectRequirement._();

  factory SubjectServiceSubjectRequirement([void updates(SubjectServiceSubjectRequirementBuilder b)]) = _$SubjectServiceSubjectRequirement;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubjectServiceSubjectRequirementBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectServiceSubjectRequirement> get serializer => _$SubjectServiceSubjectRequirementSerializer();
}

class _$SubjectServiceSubjectRequirementSerializer implements PrimitiveSerializer<SubjectServiceSubjectRequirement> {
  @override
  final Iterable<Type> types = const [SubjectServiceSubjectRequirement, _$SubjectServiceSubjectRequirement];

  @override
  final String wireName = r'SubjectServiceSubjectRequirement';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectServiceSubjectRequirement object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'course';
    yield serializers.serialize(
      object.course,
      specifiedType: const FullType(DottoFoundationV1Course),
    );
    yield r'requirementType';
    yield serializers.serialize(
      object.requirementType,
      specifiedType: const FullType(DottoFoundationV1SubjectRequirementType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubjectServiceSubjectRequirement object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectServiceSubjectRequirementBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'course':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Course),
          ) as DottoFoundationV1Course;
          result.course = valueDes;
          break;
        case r'requirementType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1SubjectRequirementType),
          ) as DottoFoundationV1SubjectRequirementType;
          result.requirementType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubjectServiceSubjectRequirement deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectServiceSubjectRequirementBuilder();
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

