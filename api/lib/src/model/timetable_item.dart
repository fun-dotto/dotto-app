//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_period.dart';
import 'package:openapi/src/model/subject_summary.dart';
import 'package:openapi/src/model/dotto_foundation_v1_day_of_week.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'timetable_item.g.dart';

/// TimetableItem
///
/// Properties:
/// * [id] 
/// * [subject] 
/// * [dayOfWeek] 
/// * [period] 
@BuiltValue()
abstract class TimetableItem implements Built<TimetableItem, TimetableItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subject')
  SubjectSummary get subject;

  @BuiltValueField(wireName: r'dayOfWeek')
  DottoFoundationV1DayOfWeek get dayOfWeek;
  // enum dayOfWeekEnum {  Sunday,  Monday,  Tuesday,  Wednesday,  Thursday,  Friday,  Saturday,  };

  @BuiltValueField(wireName: r'period')
  DottoFoundationV1Period get period;
  // enum periodEnum {  Period1,  Period2,  Period3,  Period4,  Period5,  Period6,  };

  TimetableItem._();

  factory TimetableItem([void updates(TimetableItemBuilder b)]) = _$TimetableItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TimetableItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TimetableItem> get serializer => _$TimetableItemSerializer();
}

class _$TimetableItemSerializer implements PrimitiveSerializer<TimetableItem> {
  @override
  final Iterable<Type> types = const [TimetableItem, _$TimetableItem];

  @override
  final String wireName = r'TimetableItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TimetableItem object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    TimetableItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TimetableItemBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TimetableItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TimetableItemBuilder();
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

