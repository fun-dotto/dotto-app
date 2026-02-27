//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/subject_service_subject_requirement.dart';
import 'package:openapi/src/model/subject_service_syllabus.dart';
import 'package:openapi/src/model/dotto_foundation_v1_course_semester.dart';
import 'package:openapi/src/model/subject_service_subject_target_class.dart';
import 'package:openapi/src/model/subject_service_subject_faculty.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subject_detail.g.dart';

/// SubjectDetail
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [faculties] 
/// * [semester] 
/// * [credit] - 単位数
/// * [eligibleAttributes] - 授業名末尾の`学年-クラス`をもとに決定
/// * [requirements] - 科目群・科目区分をもとに決定
/// * [syllabus] 
@BuiltValue()
abstract class SubjectDetail implements Built<SubjectDetail, SubjectDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'faculties')
  BuiltList<SubjectServiceSubjectFaculty> get faculties;

  @BuiltValueField(wireName: r'semester')
  DottoFoundationV1CourseSemester get semester;
  // enum semesterEnum {  AllYear,  H1,  H2,  Q1,  Q2,  Q3,  Q4,  SummerIntensive,  WinterIntensive,  };

  /// 単位数
  @BuiltValueField(wireName: r'credit')
  int get credit;

  /// 授業名末尾の`学年-クラス`をもとに決定
  @BuiltValueField(wireName: r'eligibleAttributes')
  BuiltList<SubjectServiceSubjectTargetClass> get eligibleAttributes;

  /// 科目群・科目区分をもとに決定
  @BuiltValueField(wireName: r'requirements')
  BuiltList<SubjectServiceSubjectRequirement> get requirements;

  @BuiltValueField(wireName: r'syllabus')
  SubjectServiceSyllabus get syllabus;

  SubjectDetail._();

  factory SubjectDetail([void updates(SubjectDetailBuilder b)]) = _$SubjectDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubjectDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectDetail> get serializer => _$SubjectDetailSerializer();
}

class _$SubjectDetailSerializer implements PrimitiveSerializer<SubjectDetail> {
  @override
  final Iterable<Type> types = const [SubjectDetail, _$SubjectDetail];

  @override
  final String wireName = r'SubjectDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectDetail object, {
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
    yield r'faculties';
    yield serializers.serialize(
      object.faculties,
      specifiedType: const FullType(BuiltList, [FullType(SubjectServiceSubjectFaculty)]),
    );
    yield r'semester';
    yield serializers.serialize(
      object.semester,
      specifiedType: const FullType(DottoFoundationV1CourseSemester),
    );
    yield r'credit';
    yield serializers.serialize(
      object.credit,
      specifiedType: const FullType(int),
    );
    yield r'eligibleAttributes';
    yield serializers.serialize(
      object.eligibleAttributes,
      specifiedType: const FullType(BuiltList, [FullType(SubjectServiceSubjectTargetClass)]),
    );
    yield r'requirements';
    yield serializers.serialize(
      object.requirements,
      specifiedType: const FullType(BuiltList, [FullType(SubjectServiceSubjectRequirement)]),
    );
    yield r'syllabus';
    yield serializers.serialize(
      object.syllabus,
      specifiedType: const FullType(SubjectServiceSyllabus),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubjectDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectDetailBuilder result,
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
        case r'faculties':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SubjectServiceSubjectFaculty)]),
          ) as BuiltList<SubjectServiceSubjectFaculty>;
          result.faculties.replace(valueDes);
          break;
        case r'semester':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1CourseSemester),
          ) as DottoFoundationV1CourseSemester;
          result.semester = valueDes;
          break;
        case r'credit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.credit = valueDes;
          break;
        case r'eligibleAttributes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SubjectServiceSubjectTargetClass)]),
          ) as BuiltList<SubjectServiceSubjectTargetClass>;
          result.eligibleAttributes.replace(valueDes);
          break;
        case r'requirements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SubjectServiceSubjectRequirement)]),
          ) as BuiltList<SubjectServiceSubjectRequirement>;
          result.requirements.replace(valueDes);
          break;
        case r'syllabus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubjectServiceSyllabus),
          ) as SubjectServiceSyllabus;
          result.syllabus.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubjectDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectDetailBuilder();
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

