import 'package:dotto/domain/bus_stop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_timetable_stop.freezed.dart';

@freezed
abstract class BusTimetableStop with _$BusTimetableStop {
  const factory BusTimetableStop({
    required String tripId,
    required BusStop stop,
    required DateTime departureTime,
  }) = _BusTimetableStop;
}
