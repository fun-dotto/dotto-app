//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_period.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/dotto_foundation_v1_day_of_week.dart';
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
/// * [dayOfWeek] - TODO: Timetable API から曜日を取得する 曜日
/// * [period] - TODO: Timetable API から時限を取得する 時限
/// * [isAddedToTimetable] - TODO: 時間割APIを作成したら、時間割に追加されているかを取得する 時間割に追加されているか
@BuiltValue()
abstract class SubjectSummary implements Built<SubjectSummary, SubjectSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'faculties')
  BuiltList<SubjectFaculty> get faculties;

  /// TODO: Timetable API から曜日を取得する 曜日
  @BuiltValueField(wireName: r'dayOfWeek')
  DottoFoundationV1DayOfWeek get dayOfWeek;
  // enum dayOfWeekEnum {  Sunday,  Monday,  Tuesday,  Wednesday,  Thursday,  Friday,  Saturday,  };

  /// TODO: Timetable API から時限を取得する 時限
  @BuiltValueField(wireName: r'period')
  DottoFoundationV1Period get period;
  // enum periodEnum {  Period1,  Period2,  Period3,  Period4,  Period5,  Period6,  };

  /// TODO: 時間割APIを作成したら、時間割に追加されているかを取得する 時間割に追加されているか
  @BuiltValueField(wireName: r'isAddedToTimetable')
  bool get isAddedToTimetable;

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
    yield r'dayOfWeek';
    yield serializers.serialize(
      object.dayOfWeek,
      specifiedType: const FullType(DottoFoundationV1DayOfWeek),
    );
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(DottoFoundationV1Period),
    );
    yield r'isAddedToTimetable';
    yield serializers.serialize(
      object.isAddedToTimetable,
      specifiedType: const FullType(bool),
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
        case r'dayOfWeek':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1DayOfWeek),
          ) as DottoFoundationV1DayOfWeek;
          result.dayOfWeek = valueDes;
          break;
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Period),
          ) as DottoFoundationV1Period;
          result.period = valueDes;
          break;
        case r'isAddedToTimetable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isAddedToTimetable = valueDes;
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

