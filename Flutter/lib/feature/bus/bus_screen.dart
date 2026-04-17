import 'package:collection/collection.dart';
import 'package:dotto/feature/bus/bus_card.dart';
import 'package:dotto/feature/bus/bus_reducer.dart';
import 'package:dotto/feature/bus/bus_stop_select.dart';
import 'package:dotto/feature/bus/bus_timetable.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final GlobalKey<State<StatefulWidget>> busKey = GlobalKey();

const int _funBusStopId = 14023;
const String _funBusStopName = 'はこだて未来大学';

final class BusScreen extends HookConsumerWidget {
  const BusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(busReducerProvider);
    final value = state.asData?.value;
    final isTo = value?.isTo ?? true;
    final isWeekday = value?.isWeekday ?? true;
    final myBusStopName = value?.myBusStop.name ?? '';

    final tabController = useTabController(
      initialLength: 2,
      initialIndex: isWeekday ? 0 : 1,
    );
    final scrollController = useScrollController();

    useEffect(() {
      final desiredIndex = isWeekday ? 0 : 1;
      if (tabController.index != desiredIndex) {
        tabController.index = desiredIndex;
      }
      return null;
    }, [isWeekday]);

    useEffect(() {
      void listener() {
        if (tabController.indexIsChanging) return;
        final currentIsWeekday = tabController.index == 0;
        if (currentIsWeekday != isWeekday) {
          ref.read(busReducerProvider.notifier).toggleWeekday();
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController, isWeekday]);

    final fromCard = _BusStopCard(
      icon: isTo ? Icons.pin_drop : Icons.school,
      label: isTo ? myBusStopName : _funBusStopName,
      elevation: isTo ? 1 : 0,
      onTap: isTo
          ? () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const BusStopSelectScreen(),
                  settings: const RouteSettings(name: '/bus/select_stop'),
                ),
              );
            }
          : null,
    );
    final toCard = _BusStopCard(
      icon: isTo ? Icons.school : Icons.pin_drop,
      label: isTo ? _funBusStopName : myBusStopName,
      elevation: isTo ? 0 : 1,
      onTap: isTo
          ? null
          : () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const BusStopSelectScreen(),
                  settings: const RouteSettings(name: '/bus/select_stop'),
                ),
              );
            },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'バス',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: SemanticColor.light.accentPrimary,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(128),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: ref
                          .read(busReducerProvider.notifier)
                          .toggleDirection,
                      icon: Icon(
                        Icons.swap_vert_outlined,
                        size: 24,
                        color: SemanticColor.light.labelSecondary,
                      ),
                    ),
                    Flexible(
                      child: Column(children: [fromCard, toCard]),
                    ),
                  ],
                ),
              ),
              TabBar(
                dividerColor: Colors.transparent,
                controller: tabController,
                tabs: const [
                  Tab(text: '平日'),
                  Tab(text: '休日'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: () {
        switch (state) {
          case AsyncData(:final value):
            final fromToString = value.isTo ? 'to_fun' : 'from_fun';

            var arriveAtSoon = true;
            final tripWidgets = value
                .trips[fromToString]![value.isWeekday ? 'weekday' : 'holiday']!
                .map((busTrip) {
                  final funBusTripStop = busTrip.stops.firstWhereOrNull(
                    (element) => element.stop.id == _funBusStopId,
                  );
                  if (funBusTripStop == null) {
                    return Container();
                  }
                  var targetBusTripStop = busTrip.stops.firstWhereOrNull(
                    (element) => element.stop.id == value.myBusStop.id,
                  );
                  var kameda = false;
                  if (targetBusTripStop == null) {
                    targetBusTripStop = busTrip.stops.firstWhere(
                      (element) => element.stop.id == 14013,
                    );
                    kameda = true;
                  }
                  final fromBusTripStop = value.isTo
                      ? targetBusTripStop
                      : funBusTripStop;
                  final toBusTripStop = value.isTo
                      ? funBusTripStop
                      : targetBusTripStop;
                  final nowDuration = Duration(
                    hours: value.currentTime.hour,
                    minutes: value.currentTime.minute,
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
                          settings: RouteSettings(
                            name: '/bus/timetable?route=${busTrip.route}',
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
                        isTo: value.isTo,
                        myBusStopName: value.myBusStop.name,
                        isKameda: kameda,
                        key: hasKey ? busKey : null,
                      ),
                    ),
                  );
                })
                .toList();

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (value.isScrolled) return;
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

            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(spacing: 8, children: tripWidgets),
              ),
            );
          case AsyncError():
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('エラーが発生しました')),
            );
          case AsyncLoading():
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      }(),
    );
  }
}

final class _BusStopCard extends StatelessWidget {
  const _BusStopCard({
    required this.icon,
    required this.label,
    required this.elevation,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final double elevation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          spacing: 8,
          children: [
            Icon(icon, size: 16, color: SemanticColor.light.labelSecondary),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      splashColor: SemanticColor.light.borderPrimary,
      child: card,
    );
  }
}
