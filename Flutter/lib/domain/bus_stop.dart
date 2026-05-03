import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_stop.freezed.dart';

@freezed
abstract class BusStop with _$BusStop {
  const factory BusStop({
    required int id,
    required String name,
    required List<String> routeList,
    bool? reverse,
    bool? selectable,
  }) = _BusStop;

  @Deprecated('ドメインモデルでFirebaseからの変換を行うことは不適切。Dotto API導入後に削除予定。')
  factory BusStop.fromFirebase(Map<String, dynamic> map) {
    final routeList = (map['route'] as List).map((e) => e.toString()).toList();
    return BusStop(
      id: map['id'] as int,
      name: map['name'] as String,
      routeList: routeList,
      reverse: map['reverse'] as bool?,
      selectable: map['selectable'] as bool?,
    );
  }
}
