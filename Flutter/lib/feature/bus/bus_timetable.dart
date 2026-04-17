import 'package:dotto/domain/bus_trip.dart';
import 'package:dotto/feature/bus/bus_reducer.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class BusTimetableScreen extends StatelessWidget {
  const BusTimetableScreen(this.busTrip, {super.key});
  final BusTrip busTrip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(busTrip.route)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: busTrip.stops.map((busTripStop) {
            final terminal = busTripStop.terminal;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  SizedBox(
                    width: 48,
                    child: Center(
                      child: Text(
                        formatDuration(busTripStop.time),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 12,
                        decoration: BoxDecoration(
                          color: SemanticColor.light.accentPrimary,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            busTripStop.stop.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (terminal != null)
                            Text(
                              '$terminal番乗り場',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
