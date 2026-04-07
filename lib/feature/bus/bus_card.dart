import 'package:dotto/domain/bus_type.dart';
import 'package:dotto/feature/bus/bus_reducer.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class BusCard extends ConsumerWidget {
  const BusCard({
    required this.route,
    required this.beginTime,
    required this.endTime,
    required this.arriveAt,
    required this.isTo,
    required this.myBusStopName,
    super.key,
    this.isKameda = false,
    this.home = false,
  });
  final String route;
  final Duration beginTime;
  final Duration endTime;
  final Duration arriveAt;
  final bool isTo;
  final String myBusStopName;
  final bool isKameda;
  final bool home;

  BusType getType() {
    if (['55', '55A', '55B', '55C', '55E', '55F'].contains(route)) {
      return BusType.goryokaku;
    }
    if (route == '55G') {
      return BusType.syowa;
    }
    if (route == '55H') {
      return BusType.kameda;
    }
    return BusType.other;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripType = getType();
    final headerText = tripType != BusType.other
        ? tripType.where + (isTo ? 'から' : '行き')
        : '';
    return Card(
      color: Colors.white,
      shadowColor: Colors.black,
      child: Container(
        padding: EdgeInsets.only(
          top: home ? 0 : 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (home)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isTo ? '$myBusStopName → 未来大' : '未来大 → $myBusStopName',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, 5),
                    child: IconButton(
                      color: SemanticColor.light.accentInfo,
                      onPressed: () {
                        ref.read(busReducerProvider.notifier).toggleDirection();
                      },
                      icon: const Icon(Icons.swap_horiz_outlined),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            if (route != '0')
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$route $headerText'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatDuration(beginTime),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Transform.translate(
                        offset: const Offset(0, -5),
                        child: Text(isKameda && isTo ? '亀田支所発' : '発'),
                      ),
                      const Spacer(),
                      Transform.translate(
                        offset: const Offset(0, -5),
                        child: Text(
                          '${formatDuration(endTime)}'
                          '${isKameda && !isTo ? '亀田支所着' : '着'}',
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 6, color: tripType.dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text('出発まで${arriveAt.inMinutes}分')],
                  ),
                ],
              )
            else
              const Text('今日の運行は終了しました。'),
          ],
        ),
      ),
    );
  }
}
