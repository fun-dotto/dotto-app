//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/reservation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reservations_v1_list200_response.g.dart';

/// ReservationsV1List200Response
///
/// Properties:
/// * [reservations] 
@BuiltValue()
abstract class ReservationsV1List200Response implements Built<ReservationsV1List200Response, ReservationsV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'reservations')
  BuiltList<Reservation> get reservations;

  ReservationsV1List200Response._();

  factory ReservationsV1List200Response([void updates(ReservationsV1List200ResponseBuilder b)]) = _$ReservationsV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReservationsV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReservationsV1List200Response> get serializer => _$ReservationsV1List200ResponseSerializer();
}

class _$ReservationsV1List200ResponseSerializer implements PrimitiveSerializer<ReservationsV1List200Response> {
  @override
  final Iterable<Type> types = const [ReservationsV1List200Response, _$ReservationsV1List200Response];

  @override
  final String wireName = r'ReservationsV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReservationsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reservations';
    yield serializers.serialize(
      object.reservations,
      specifiedType: const FullType(BuiltList, [FullType(Reservation)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReservationsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReservationsV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reservations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Reservation)]),
          ) as BuiltList<Reservation>;
          result.reservations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReservationsV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReservationsV1List200ResponseBuilder();
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

