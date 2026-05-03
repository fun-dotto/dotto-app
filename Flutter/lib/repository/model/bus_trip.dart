import 'package:dotto/repository/model/bus_stop.dart';
import 'package:dotto/repository/model/bus_trip_stop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_trip.freezed.dart';

@freezed
abstract class BusTrip with _$BusTrip {
  const factory BusTrip({
    required String route,
    required List<BusTripStop> stops,
  }) = _BusTrip;

  @Deprecated('ドメインモデルでFirebaseからの変換を行うことは不適切。Dotto API導入後に削除予定。')
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
