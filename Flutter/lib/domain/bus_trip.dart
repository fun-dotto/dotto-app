import 'package:dotto/domain/bus_alert.dart';
import 'package:dotto/domain/bus_route.dart';
import 'package:dotto/domain/bus_stop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_trip.freezed.dart';

@freezed
abstract class BusTrip with _$BusTrip {
  const factory BusTrip({
    required String id,
    required DateTime departureTime,
    required DateTime arrivalTime,
    required BusRoute route,
    // 乗車バス停、乗り換えバス停、降車バス停のリスト
    required List<BusStop> stops,
    @Default(Duration.zero) Duration delay,
    @Default(BusAlert.none) BusAlert alert,
  }) = _BusTrip;
}
