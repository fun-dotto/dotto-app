//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/dotto_foundation_v1_course_semester.dart';
import 'package:openapi/src/model/subject_faculty.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subject_summary.g.dart';

/// SubjectSummary
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [faculties] 
/// * [year] - 開講年度
/// * [semester] - 開講時期
/// * [credit] - 単位数
@BuiltValue()
abstract class SubjectSummary implements Built<SubjectSummary, SubjectSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'faculties')
  BuiltList<SubjectFaculty> get faculties;

  /// 開講年度
  @BuiltValueField(wireName: r'year')
  int get year;

  /// 開講時期
  @BuiltValueField(wireName: r'semester')
  DottoFoundationV1CourseSemester get semester;
  // enum semesterEnum {  AllYear,  H1,  H2,  Q1,  Q2,  Q3,  Q4,  SummerIntensive,  WinterIntensive,  };

  /// 単位数
  @BuiltValueField(wireName: r'credit')
  int get credit;

  SubjectSummary._();

  factory SubjectSummary([void updates(SubjectSummaryBuilder b)]) = _$SubjectSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubjectSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectSummary> get serializer => _$SubjectSummarySerializer();
}

class _$SubjectSummarySerializer implements PrimitiveSerializer<SubjectSummary> {
  @override
  final Iterable<Type> types = const [SubjectSummary, _$SubjectSummary];

  @override
  final String wireName = r'SubjectSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectSummary object, {
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
      specifiedType: const FullType(BuiltList, [FullType(SubjectFaculty)]),
    );
    yield r'year';
    yield serializers.serialize(
      object.year,
      specifiedType: const FullType(int),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    SubjectSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectSummaryBuilder result,
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
            specifiedType: const FullType(BuiltList, [FullType(SubjectFaculty)]),
          ) as BuiltList<SubjectFaculty>;
          result.faculties.replace(valueDes);
          break;
        case r'year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.year = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubjectSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectSummaryBuilder();
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

