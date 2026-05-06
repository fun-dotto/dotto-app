import 'package:dotto/repository/model/bus_stop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_trip_stop.freezed.dart';

@freezed
abstract class BusTripStop with _$BusTripStop {
  const factory BusTripStop({
    required Duration time,
    required BusStop stop,
    int? terminal,
  }) = _BusTripStop;

  factory BusTripStop.fromFirebase(BusStop stop, Map<String, dynamic> map) {
    final timeStr = map['time'] as String;
    final timeStrList = timeStr.split(':');
    if (timeStrList.length != 2) {
      throw FormatException('Invalid time format (expected HH:mm)', timeStr);
    }
    final hour = int.tryParse(timeStrList[0]);
    final minute = int.tryParse(timeStrList[1]);
    if (hour == null || minute == null) {
      throw FormatException('Invalid time format (expected HH:mm)', timeStr);
    }
    return BusTripStop(
      time: Duration(hours: hour, minutes: minute),
      stop: stop,
      terminal: map['terminal'] as int?,
    );
  }
}
