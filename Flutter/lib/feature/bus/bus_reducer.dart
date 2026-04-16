import 'dart:async';

import 'package:dotto/domain/bus_stop.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/bus/bus_state.dart';
import 'package:dotto/helper/location_helper.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bus_reducer.g.dart';

const _defaultBusStop = BusStop(
  id: 14013,
  name: '亀田支所前',
  routeList: ['50', '55', '55A', '55B', '55C', '55E', '55F', '55G', '55H'],
);

@riverpod
final class BusReducer extends _$BusReducer {
  Timer? _pollingTimer;

  @override
  Future<BusState> build() async {
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });

    final busRepository = ref.read(busRepositoryProvider);
    final nearUniFuture = LocationHelper.isNearUniversity();

    final allStops = await busRepository.getAllBusStops();
    final trips = await busRepository.getBusTrips(allStops);

    final myBusStop = await _loadMyBusStop(allStops);
    final now = DateTime.now();
    final isNearUni = await nearUniFuture;

    _startPolling();

    return BusState(
      trips: trips,
      allStops: allStops,
      myBusStop: myBusStop,
      isWeekday: now.weekday <= DateTime.friday,
      currentTime: now,
      isTo: !isNearUni,
    );
  }

  Future<BusStop> _loadMyBusStop(List<BusStop> allStops) async {
    final savedId = await UserPreferenceRepository.getInt(
      UserPreferenceKeys.myBusStop,
    );
    if (savedId != null) {
      final found = allStops.where((s) => s.id == savedId);
      if (found.isNotEmpty) return found.first;
    }
    return _defaultBusStop;
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final current = state.asData?.value;
      if (current == null) return;
      state = AsyncData(current.copyWith(currentTime: DateTime.now()));
    });
  }

  void toggleDirection() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(isTo: !current.isTo, isScrolled: false));
  }

  void toggleWeekday() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(isWeekday: !current.isWeekday, isScrolled: false),
    );
  }

  Future<void> selectBusStop(BusStop busStop) async {
    await UserPreferenceRepository.setInt(
      UserPreferenceKeys.myBusStop,
      busStop.id,
    );
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(myBusStop: busStop));
  }

  void setScrolled({required bool value}) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(isScrolled: value));
  }
}

String formatDuration(Duration d) {
  String twoDigits(int n) {
    if (n.isNaN) return '00';
    return n.toString().padLeft(2, '0').substring(0, 2);
  }

  final negativeSign = d.isNegative ? '-' : '';
  final hour = d.inHours.abs();
  final min = d.inMinutes.remainder(60).abs();
  final strHour = twoDigits(hour);
  final strMin = twoDigits(min);

  return '$negativeSign$strHour:$strMin';
}
