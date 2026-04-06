import 'package:dotto/feature/bus/domain/bus_stop.dart';
import 'package:dotto/feature/bus/domain/bus_trip.dart';
import 'package:dotto/helper/firebase_realtime_database_repository.dart';

abstract class BusRepository {
  Future<List<BusStop>> getAllBusStops();
  Future<Map<String, Map<String, List<BusTrip>>>> getBusTrips(List<BusStop> allBusStops);
}

final class BusRepositoryImpl implements BusRepository {
  BusRepositoryImpl(this._database);

  final FirebaseRealtimeDatabaseRepository _database;

  @override
  Future<List<BusStop>> getAllBusStops() async {
    final snapshot = await _database.getData('bus/stops');
    if (snapshot.exists) {
      final busDataStops = snapshot.value! as List;
      return busDataStops.map((e) => BusStop.fromFirebase(Map<String, dynamic>.from(e as Map))).toList();
    } else {
      throw Exception('Failed to fetch bus stops');
    }
  }

  @override
  Future<Map<String, Map<String, List<BusTrip>>>> getBusTrips(List<BusStop> allBusStops) async {
    final snapshot = await _database.getData('bus/trips');
    if (snapshot.exists) {
      final busTripsData = snapshot.value! as Map;
      final allBusTrips = <String, Map<String, List<BusTrip>>>{
        'from_fun': {'holiday': [], 'weekday': []},
        'to_fun': {'holiday': [], 'weekday': []},
      };
      busTripsData.forEach((key, value) {
        final fromTo = key as String;
        (value as Map).forEach((key2, value2) {
          final week = key2 as String;
          allBusTrips[fromTo]![week] = (value2 as List)
              .map((e) => BusTrip.fromFirebase(Map<String, dynamic>.from(e as Map), allBusStops))
              .toList();
        });
      });
      return allBusTrips;
    } else {
      throw Exception('Failed to fetch bus trips');
    }
  }
}
