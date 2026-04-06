//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_period.dart';
import 'package:openapi/src/model/subject_summary.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancelled_class.g.dart';

/// 休講
///
/// Properties:
/// * [id] 
/// * [subject] 
/// * [date] 
/// * [period] 
/// * [comment] 
@BuiltValue()
abstract class CancelledClass implements Built<CancelledClass, CancelledClassBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subject')
  SubjectSummary get subject;

  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'period')
  DottoFoundationV1Period get period;
  // enum periodEnum {  Period1,  Period2,  Period3,  Period4,  Period5,  Period6,  };

  @BuiltValueField(wireName: r'comment')
  String get comment;

  CancelledClass._();

  factory CancelledClass([void updates(CancelledClassBuilder b)]) = _$CancelledClass;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancelledClassBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancelledClass> get serializer => _$CancelledClassSerializer();
}

class _$CancelledClassSerializer implements PrimitiveSerializer<CancelledClass> {
  @override
  final Iterable<Type> types = const [CancelledClass, _$CancelledClass];

  @override
  final String wireName = r'CancelledClass';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancelledClass object, {
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
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(DottoFoundationV1Period),
    );
    yield r'comment';
    yield serializers.serialize(
      object.comment,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancelledClass object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancelledClassBuilder result,
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
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Period),
          ) as DottoFoundationV1Period;
          result.period = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.comment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancelledClass deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancelledClassBuilder();
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

