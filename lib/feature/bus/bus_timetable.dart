import 'package:dotto/domain/bus_trip.dart';
import 'package:dotto/feature/bus/bus_reducer.dart';
import 'package:flutter/material.dart';

final class BusTimetableScreen extends StatelessWidget {
  const BusTimetableScreen(this.busTrip, {super.key});
  final BusTrip busTrip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(busTrip.route)),
      body: ListView(
        children: busTrip.stops.map((busTripStop) {
          final terminal = busTripStop.terminal;
          return ListTile(
            title: Text(busTripStop.stop.name),
            trailing: Text(formatDuration(busTripStop.time), style: Theme.of(context).textTheme.labelMedium),
            subtitle: terminal != null ? Text('$terminal番乗り場') : null,
          );
        }).toList(),
      ),
    );
  }
}
