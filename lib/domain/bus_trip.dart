import 'package:dotto/domain/bus_stop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_trip.freezed.dart';

@freezed
abstract class BusTripStop with _$BusTripStop {
  const factory BusTripStop({
    required Duration time,
    required BusStop stop,
    int? terminal,
  }) = _BusTripStop;

  factory BusTripStop.fromFirebase(BusStop stop, Map<String, dynamic> map) {
    final timeStrList = (map['time'] as String).split(':');
    final hour = int.parse(timeStrList[0]);
    final minute = int.parse(timeStrList[1]);
    return BusTripStop(
      time: Duration(hours: hour, minutes: minute),
      stop: stop,
      terminal: map['terminal'] as int?,
    );
  }
}

@freezed
abstract class BusTrip with _$BusTrip {
  const factory BusTrip({
    required String route,
    required List<BusTripStop> stops,
  }) = _BusTrip;

  factory BusTrip.fromFirebase(
    Map<String, dynamic> map,
    List<BusStop> allStops,
  ) {
    final stopsList = map['stops'] as List;
    return BusTrip(
      route: map['route'] as String,
      stops: stopsList.map((e) {
        final stopMap = Map<String, dynamic>.from(e as Map);
        final id = stopMap['id'] as int;
        final targetBusStop = allStops.firstWhere(
          (busStop) => busStop.id == id,
        );
        return BusTripStop.fromFirebase(targetBusStop, stopMap);
      }).toList(),
    );
  }
}
