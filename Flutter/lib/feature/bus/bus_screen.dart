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
    final state = ref.watch(busReducerProvider);
    final tabController = useTabController(initialLength: 2);
    final scrollController = useScrollController();

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
                      child: Column(
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                spacing: 8,
                                children: [
                                  Icon(
                                    Icons.school,
                                    size: 16,
                                    color: SemanticColor.light.labelSecondary,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'はこだて未来大学',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle tap event
                            },
                            splashColor: SemanticColor.light.borderPrimary,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      Icons.pin_drop,
                                      size: 16,
                                      color: SemanticColor.light.labelSecondary,
                                    ),
                                    Expanded(
                                      child: Text(
                                        // TODO: 選択したバス停の名前
                                        '五稜郭',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
            final myBusStopButton = _busStopButton(
              context,
              () async {
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const BusStopSelectScreen(),
                    settings: const RouteSettings(name: '/bus/select_stop'),
                  ),
                );
              },
              Icons.directions_bus,
              value.myBusStop.name,
            );
            final funBusStopButton = _busStopButton(
              context,
              null,
              Icons.school,
              '未来大',
            );
            final departure = value.isTo ? myBusStopButton : funBusStopButton;
            final destination = value.isTo ? funBusStopButton : myBusStopButton;
            final fromToString = value.isTo ? 'to_fun' : 'from_fun';

            final btnChange = IconButton(
              iconSize: 20,
              color: SemanticColor.light.accentInfo,
              onPressed: () {
                ref.read(busReducerProvider.notifier).toggleDirection();
              },
              icon: const Icon(Icons.swap_horiz_outlined),
            );

            var arriveAtSoon = true;
            final tripWidgets = value
                .trips[fromToString]![value.isWeekday ? 'weekday' : 'holiday']!
                .map((busTrip) {
                  final funBusTripStop = busTrip.stops.firstWhereOrNull(
                    (element) => element.stop.id == 14023,
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

            return Column(
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
