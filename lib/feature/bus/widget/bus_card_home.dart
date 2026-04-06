import 'package:collection/collection.dart';
import 'package:dotto/feature/bus/bus.dart';
import 'package:dotto/feature/bus/bus_reducer.dart';
import 'package:dotto/feature/bus/widget/bus_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class BusCardHome extends ConsumerWidget {
  const BusCardHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busState = ref.watch(busReducerProvider);

    return busState.when(
      data: (state) {
        final fromToString = state.isTo ? 'to_fun' : 'from_fun';
        final dataOfDay = state.trips[fromToString]![state.isWeekday ? 'weekday' : 'holiday']!;
        for (final busTrip in dataOfDay) {
          final funBusTripStop = busTrip.stops.firstWhereOrNull((element) => element.stop.id == 14023);
          if (funBusTripStop == null) {
            continue;
          }
          var targetBusTripStop = busTrip.stops.firstWhereOrNull((element) => element.stop.id == state.myBusStop.id);
          var kameda = false;
          if (targetBusTripStop == null) {
            targetBusTripStop = busTrip.stops.firstWhere((element) => element.stop.id == 14013);
            kameda = true;
          }
          final fromBusTripStop = state.isTo ? targetBusTripStop : funBusTripStop;
          final toBusTripStop = state.isTo ? funBusTripStop : targetBusTripStop;
          final nowDuration = Duration(hours: state.currentTime.hour, minutes: state.currentTime.minute);
          final arriveAt = fromBusTripStop.time - nowDuration;
          if (arriveAt.isNegative) {
            continue;
          }
          return InkWell(
            onTap: () {
              ref.read(busReducerProvider.notifier).setScrolled(value: false);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const BusScreen(),
                  settings: const RouteSettings(name: '/home/bus'),
                ),
              );
            },
            child: BusCard(
              route: busTrip.route,
              beginTime: fromBusTripStop.time,
              endTime: toBusTripStop.time,
              arriveAt: arriveAt,
              isTo: state.isTo,
              myBusStopName: state.myBusStop.name,
              isKameda: kameda,
              home: true,
            ),
          );
        }
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const BusScreen(),
                settings: const RouteSettings(name: '/home/bus'),
              ),
            );
          },
          child: const BusCard(
            route: '0',
            beginTime: Duration.zero,
            endTime: Duration.zero,
            arriveAt: Duration.zero,
            isTo: true,
            myBusStopName: '',
            home: true,
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
