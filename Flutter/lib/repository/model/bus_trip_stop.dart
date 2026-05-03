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

  @Deprecated('ドメインモデルでFirebaseからの変換を行うことは不適切。Dotto API導入後に削除予定。')
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
