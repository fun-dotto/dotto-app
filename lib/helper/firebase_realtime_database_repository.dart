import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

final class FirebaseRealtimeDatabaseRepository {
  factory FirebaseRealtimeDatabaseRepository() {
    return _instance;
  }
  FirebaseRealtimeDatabaseRepository._internal();
  static final FirebaseRealtimeDatabaseRepository _instance =
      FirebaseRealtimeDatabaseRepository._internal();

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://swift2023groupc-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  Future<DataSnapshot> getData(String path) async {
    return _database.ref().child(path).get();
  }
}
