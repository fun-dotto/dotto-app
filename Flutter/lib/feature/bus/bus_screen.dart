import 'package:collection/collection.dart';
import 'package:dotto/domain/bus_type.dart';
import 'package:dotto/feature/bus/bus_reducer.dart';
import 'package:dotto/feature/bus/bus_stop_select.dart';
import 'package:dotto/feature/bus/bus_timetable.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final GlobalKey<State<StatefulWidget>> weekdayBusKey = GlobalKey();
final GlobalKey<State<StatefulWidget>> holidayBusKey = GlobalKey();

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

    final weekdayScrollController = useScrollController();
    final holidayScrollController = useScrollController();

    final tabController = useTabController(
      initialLength: 2,
      initialIndex: isWeekday ? 0 : 1,
    );
    final isWeekdayRef = useRef(isWeekday)..value = isWeekday;

    useEffect(() {
      void listener() {
        if (tabController.indexIsChanging) return;
        final currentIsWeekday = tabController.index == 0;
        if (currentIsWeekday != isWeekdayRef.value) {
          ref.read(busReducerProvider.notifier).toggleWeekday();
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    useEffect(() {
      final desiredIndex = isWeekday ? 0 : 1;
      if (tabController.index != desiredIndex) {
        tabController.index = desiredIndex;
      }
      return null;
    }, [isWeekday]);

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
          preferredSize: const Size.fromHeight(96),
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
                    Flexible(child: Column(children: [fromCard, toCard])),
                  ],
                ),
              ),
              TabBar(
                dividerColor: SemanticColor.light.borderPrimary,
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
            List<Widget> buildTripWidgets({
              required bool weekday,
              required GlobalKey scrollKey,
            }) {
              final fromToString = value.isTo ? 'to_fun' : 'from_fun';
              var arriveAtSoon = true;
              return value
                  .trips[fromToString]![weekday ? 'weekday' : 'holiday']!
                  .where(
                    (busTrip) => busTrip.stops.any(
                      (element) => element.stop.id == _funBusStopId,
                    ),
                  )
                  .map((busTrip) {
                    final funBusTripStop = busTrip.stops.firstWhere(
                      (element) => element.stop.id == _funBusStopId,
                    );
                    var targetBusTripStop = busTrip.stops.firstWhereOrNull(
                      (element) => element.stop.id == value.myBusStop.id,
                    );
                    var kameda = false;
                    if (targetBusTripStop == null) {
                      targetBusTripStop = busTrip.stops.firstWhere(
                        (element) => element.stop.id == kamedaBusStopId,
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
                    return _BusTripTile(
                      key: hasKey ? scrollKey : null,
                      route: busTrip.route,
                      beginTime: fromBusTripStop.time,
                      endTime: toBusTripStop.time,
                      isTo: value.isTo,
                      isKameda: kameda,
                      myBusStopName: value.myBusStop.name,
                      onTap: busTrip.route == '0'
                          ? null
                          : () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) =>
                                      BusTimetableScreen(busTrip),
                                  settings: RouteSettings(
                                    name:
                                        '/bus/timetable?route=${busTrip.route}',
                                  ),
                                ),
                              );
                            },
                    );
                  })
                  .toList();
            }

            final weekdayTripWidgets = buildTripWidgets(
              weekday: true,
              scrollKey: weekdayBusKey,
            );
            final holidayTripWidgets = buildTripWidgets(
              weekday: false,
              scrollKey: holidayBusKey,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final alreadyScrolled = value.isWeekday
                  ? value.isWeekdayScrolled
                  : value.isHolidayScrolled;
              if (alreadyScrolled) return;
              final activeController = value.isWeekday
                  ? weekdayScrollController
                  : holidayScrollController;
              final activeKey = value.isWeekday ? weekdayBusKey : holidayBusKey;
              if (activeController.hasClients && activeController.offset != 0) {
                activeController.jumpTo(0);
              }
              final currentContext = activeKey.currentContext;
              if (currentContext == null) return;
              await Scrollable.ensureVisible(
                currentContext,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
              final notifier = ref.read(busReducerProvider.notifier);
              if (value.isWeekday) {
                notifier.setWeekdayScrolled(value: true);
              } else {
                notifier.setHolidayScrolled(value: true);
              }
            });

            return TabBarView(
              controller: tabController,
              children: [
                _KeepAliveTab(
                  child: ListView.separated(
                    controller: weekdayScrollController,
                    cacheExtent: 10000,
                    itemCount: weekdayTripWidgets.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) => weekdayTripWidgets[index],
                  ),
                ),
                _KeepAliveTab(
                  child: ListView.separated(
                    controller: holidayScrollController,
                    cacheExtent: 10000,
                    itemCount: holidayTripWidgets.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) => holidayTripWidgets[index],
                  ),
                ),
              ],
            );
          case AsyncError():
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('エラーが発生しました')),
            );
          case AsyncLoading():
            return const Center(child: CircularProgressIndicator());
        }
      }(),
    );
  }
}

final class _KeepAliveTab extends StatefulWidget {
  const _KeepAliveTab({required this.child});

  final Widget child;

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
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
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      splashColor: SemanticColor.light.borderPrimary,
      child: card,
    );
  }
}

final class _BusTripTile extends StatelessWidget {
  const _BusTripTile({
    required this.route,
    required this.beginTime,
    required this.endTime,
    required this.isTo,
    required this.isKameda,
    required this.myBusStopName,
    this.onTap,
    super.key,
  });

  final String route;
  final Duration beginTime;
  final Duration endTime;
  final bool isTo;
  final bool isKameda;
  final String myBusStopName;
  final VoidCallback? onTap;

  BusType _busType() {
    if (['55', '55A', '55B', '55C', '55E', '55F'].contains(route)) {
      return BusType.goryokaku;
    }
    if (route == '55G') return BusType.syowa;
    if (route == '55H') return BusType.kameda;
    return BusType.other;
  }

  @override
  Widget build(BuildContext context) {
    if (route == '0') {
      return const ListTile(title: Text('今日の運行は終了しました。'));
    }
    final boardStop = isTo
        ? (isKameda ? '亀田支所前' : myBusStopName)
        : _funBusStopName;
    final alightStop = isTo
        ? _funBusStopName
        : (isKameda ? '亀田支所前' : myBusStopName);
    final tripType = _busType();
    final directionText = tripType != BusType.other
        ? '${tripType.where}${isTo ? 'から' : '行き'}'
        : '';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  '${formatDuration(beginTime)} → ${formatDuration(endTime)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  directionText.isEmpty ? route : '$route $directionText',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: SemanticColor.light.labelSecondary,
                  ),
                ),
                Row(
                  spacing: 4,
                  children: [
                    Icon(
                      Icons.directions_bus,
                      size: 20,
                      color: SemanticColor.light.accentPrimary,
                    ),
                    Text(boardStop),
                    const Text('-'),
                    Text(alightStop),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: SemanticColor.light.labelSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
