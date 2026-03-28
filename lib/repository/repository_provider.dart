import 'package:dotto/repository/lecture_cancellation_repository.dart';
import 'package:dotto/repository/personal_calendar_repository.dart';
import 'package:dotto/repository/room_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomRepositoryProvider = Provider<RoomRepository>((_) => RoomRepositoryImpl());

final personalCalendarRepositoryProvider = Provider<PersonalCalendarRepository>(
  (_) => PersonalCalendarRepositoryImpl(),
);

final lectureCancellationRepositoryProvider = Provider<LectureCancellationRepository>(
  (_) => LectureCancellationRepositoryImpl(),
);
