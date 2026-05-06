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

  factory BusStop.fromFirebase(Map<String, dynamic> map) {
    final rawId = map['id'];
    final id = switch (rawId) {
      final int v => v,
      final num v => v.toInt(),
      final String v => int.tryParse(v) ??
          (throw FormatException('Invalid BusStop id', v)),
      _ => throw FormatException('Invalid BusStop id', rawId),
    };
    final rawRoute = map['route'];
    if (rawRoute is! List) {
      throw FormatException('BusStop route must be a list', rawRoute);
    }
    final routeList = rawRoute.map((e) => e.toString()).toList();
    return BusStop(
      id: id,
      name: map['name'] as String,
      routeList: routeList,
      reverse: map['reverse'] as bool?,
      selectable: map['selectable'] as bool?,
    );
  }
}
