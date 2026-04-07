import 'package:dotto/domain/bus_stop.dart';
import 'package:dotto/domain/bus_trip.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:dotto/helper/firebase_realtime_database_repository.dart';

abstract class BusRepository {
  Future<List<BusStop>> getAllBusStops();
  Future<Map<String, Map<String, List<BusTrip>>>> getBusTrips(
    List<BusStop> allBusStops,
  );
}

final class BusRepositoryImpl implements BusRepository {
  BusRepositoryImpl(this._database);

  final FirebaseRealtimeDatabaseRepository _database;

  @override
  Future<List<BusStop>> getAllBusStops() async {
    try {
      final snapshot = await _database.getData('bus/stops');
      if (!snapshot.exists) {
        throw const DomainError(
          type: DomainErrorType.notFound,
          message: 'Failed to fetch bus stops',
        );
      }
      final busDataStops = snapshot.value! as List;
      return busDataStops
          .map((e) => BusStop.fromFirebase(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DomainError {
      rethrow;
    } on Exception catch (e, stackTrace) {
      throw DomainError.fromException(e: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<Map<String, Map<String, List<BusTrip>>>> getBusTrips(
    List<BusStop> allBusStops,
  ) async {
    try {
      final snapshot = await _database.getData('bus/trips');
      if (!snapshot.exists) {
        throw const DomainError(
          type: DomainErrorType.notFound,
          message: 'Failed to fetch bus trips',
        );
      }
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
              .map(
                (e) => BusTrip.fromFirebase(
                  Map<String, dynamic>.from(e as Map),
                  allBusStops,
                ),
              )
              .toList();
        });
      });
      return allBusTrips;
    } on DomainError {
      rethrow;
    } on Exception catch (e, stackTrace) {
      throw DomainError.fromException(e: e, stackTrace: stackTrace);
    }
  }
}
