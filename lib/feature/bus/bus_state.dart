import 'package:dotto/domain/bus_stop.dart';
import 'package:dotto/domain/bus_trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_state.freezed.dart';

@freezed
abstract class BusState with _$BusState {
  const factory BusState({
    /// {from_fun: {holiday: [], weekday: []}, to_fun: {holiday: [], weekday: []}}
    required Map<String, Map<String, List<BusTrip>>> trips,
    required List<BusStop> allStops,
    required BusStop myBusStop,
    @Default(true) bool isTo,
    required bool isWeekday,
    @Default(false) bool isScrolled,
    required DateTime currentTime,
  }) = _BusState;
}
