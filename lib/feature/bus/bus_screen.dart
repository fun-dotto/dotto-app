import 'package:collection/collection.dart';
import 'package:dotto/asset.dart';
import 'package:dotto/feature/bus/bus_card.dart';
import 'package:dotto/feature/bus/bus_reducer.dart';
import 'package:dotto/feature/bus/bus_stop_select.dart';
import 'package:dotto/feature/bus/bus_timetable.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final GlobalKey<State<StatefulWidget>> busKey = GlobalKey();

final class BusScreen extends HookConsumerWidget {
  const BusScreen({super.key});

  Widget _busStopButton(
    BuildContext context,
    void Function()? onPressed,
    IconData icon,
    String title,
  ) {
    final width = MediaQuery.sizeOf(context).width * 0.3;
    const double height = 80;
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.white,
          disabledForegroundColor: Colors.black87,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          fixedSize: Size(width, height),
          padding: const EdgeInsets.all(3),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: title == '未来大' ? 0 : null,
        ),
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.grey, size: 28),
              const SizedBox(height: 5),
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busState = ref.watch(busReducerProvider);
    final scrollController = useScrollController();

    return busState.when(
      data: (state) {
        final myBusStopButton = _busStopButton(
          context,
          () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const BusStopSelectScreen(),
                settings: const RouteSettings(
                  name: '/home/bus/bus_stop_select',
                ),
              ),
            );
          },
          Icons.directions_bus,
          state.myBusStop.name,
        );
        final funBusStopButton = _busStopButton(
          context,
          null,
          Icons.school,
          '未来大',
        );
        final departure = state.isTo ? myBusStopButton : funBusStopButton;
        final destination = state.isTo ? funBusStopButton : myBusStopButton;
        final fromToString = state.isTo ? 'to_fun' : 'from_fun';

        final btnChange = IconButton(
          iconSize: 20,
          color: SemanticColor.light.accentInfo,
          onPressed: () {
            ref.read(busReducerProvider.notifier).toggleDirection();
          },
          icon: const Icon(Icons.swap_horiz_outlined),
        );

        var arriveAtSoon = true;
        final tripWidgets = state
            .trips[fromToString]![state.isWeekday ? 'weekday' : 'holiday']!
            .map((busTrip) {
              final funBusTripStop = busTrip.stops.firstWhereOrNull(
                (element) => element.stop.id == 14023,
              );
              if (funBusTripStop == null) {
                return Container();
              }
              var targetBusTripStop = busTrip.stops.firstWhereOrNull(
                (element) => element.stop.id == state.myBusStop.id,
              );
              var kameda = false;
              if (targetBusTripStop == null) {
                targetBusTripStop = busTrip.stops.firstWhere(
                  (element) => element.stop.id == 14013,
                );
                kameda = true;
              }
              final fromBusTripStop = state.isTo
                  ? targetBusTripStop
                  : funBusTripStop;
              final toBusTripStop = state.isTo
                  ? funBusTripStop
                  : targetBusTripStop;
              final nowDuration = Duration(
                hours: state.currentTime.hour,
                minutes: state.currentTime.minute,
              );
              final arriveAt = fromBusTripStop.time - nowDuration;
              var hasKey = false;
              if (arriveAtSoon && arriveAt > Duration.zero) {
                arriveAtSoon = false;
                hasKey = true;
              }
              return InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => BusTimetableScreen(busTrip),
                      settings: const RouteSettings(
                        name: '/home/bus/bus_timetable',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BusCard(
                    route: busTrip.route,
                    beginTime: fromBusTripStop.time,
                    endTime: toBusTripStop.time,
                    arriveAt: arriveAt,
                    isTo: state.isTo,
                    myBusStopName: state.myBusStop.name,
                    isKameda: kameda,
                    key: hasKey ? busKey : null,
                  ),
                ),
              );
            })
            .toList();

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (state.isScrolled) return;
          final currentContext = busKey.currentContext;
          if (currentContext == null) return;
          final box = currentContext.findRenderObject()! as RenderBox;
          final position = box.localToGlobal(Offset.zero);
          await scrollController.animateTo(
            scrollController.offset + position.dy - 300,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          ref.read(busReducerProvider.notifier).setScrolled(value: true);
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'バス',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: SemanticColor.light.accentPrimary,
              ),
            ),
            centerTitle: false,
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(busReducerProvider.notifier).toggleWeekday();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.swap_horiz_outlined),
                    Text("${state.isWeekday ? "土日" : "平日"}へ "),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      Asset.bus,
                      width: MediaQuery.of(context).size.width * 0.57,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        departure,
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [btnChange],
                        ),
                        destination,
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(spacing: 8, children: tripWidgets),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => const Scaffold(body: SizedBox.shrink()),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
