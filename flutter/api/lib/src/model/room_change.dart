//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_period.dart';
import 'package:openapi/src/model/room.dart';
import 'package:openapi/src/model/subject_summary.dart';
import 'package:openapi/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'room_change.g.dart';

/// 教室変更
///
/// Properties:
/// * [id] 
/// * [subject] 
/// * [date] 
/// * [period] 
/// * [originalRoom] 
/// * [newRoom] 
@BuiltValue()
abstract class RoomChange implements Built<RoomChange, RoomChangeBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subject')
  SubjectSummary get subject;

  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'period')
  DottoFoundationV1Period get period;
  // enum periodEnum {  Period1,  Period2,  Period3,  Period4,  Period5,  Period6,  };

  @BuiltValueField(wireName: r'originalRoom')
  Room get originalRoom;

  @BuiltValueField(wireName: r'newRoom')
  Room get newRoom;

  RoomChange._();

  factory RoomChange([void updates(RoomChangeBuilder b)]) = _$RoomChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoomChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoomChange> get serializer => _$RoomChangeSerializer();
}

class _$RoomChangeSerializer implements PrimitiveSerializer<RoomChange> {
  @override
  final Iterable<Type> types = const [RoomChange, _$RoomChange];

  @override
  final String wireName = r'RoomChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoomChange object, {
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
    yield r'originalRoom';
    yield serializers.serialize(
      object.originalRoom,
      specifiedType: const FullType(Room),
    );
    yield r'newRoom';
    yield serializers.serialize(
      object.newRoom,
      specifiedType: const FullType(Room),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoomChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RoomChangeBuilder result,
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
        case r'originalRoom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Room),
          ) as Room;
          result.originalRoom.replace(valueDes);
          break;
        case r'newRoom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Room),
          ) as Room;
          result.newRoom.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoomChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomChangeBuilder();
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

