import 'package:freezed_annotation/freezed_annotation.dart';

part 'bus_route.freezed.dart';

@freezed
abstract class BusRoute with _$BusRoute {
  const factory BusRoute({required String id, required String name}) =
      _BusRoute;
}
