import 'dart:math';

import 'package:dotto/repository/model/bus_stop.dart';
import 'package:dotto/repository/model/bus_trip_stop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_trip.freezed.dart';

final Random _mockRandom = Random();

int _mockDelayMinutes() => _mockRandom.nextInt(9);

bool _mockIsCancelled() => _mockRandom.nextInt(10) == 0;

@freezed
abstract class BusTrip with _$BusTrip {
  const factory BusTrip({
    required String route,
    required List<BusTripStop> stops,
    int? delayMinutes,
    @Default(false) bool isCancelled,
  }) = _BusTrip;

  factory BusTrip.fromFirebase(
    Map<String, dynamic> map,
    List<BusStop> allStops,
  ) {
    final stopsList = map['stops'] as List;
    final busStopById = {for (final stop in allStops) stop.id: stop};
    final cancelled = _mockIsCancelled();
    return BusTrip(
      route: map['route'] as String,
      stops: stopsList.map((e) {
        final stopMap = Map<String, dynamic>.from(e as Map);
        final id = stopMap['id'] as int;
        final targetBusStop = busStopById[id];
        if (targetBusStop == null) {
          throw FormatException('Unknown bus stop id: $id');
        }
        return BusTripStop.fromFirebase(targetBusStop, stopMap);
      }).toList(),
      delayMinutes: cancelled ? null : _mockDelayMinutes(),
      isCancelled: cancelled,
    );
  }
}
