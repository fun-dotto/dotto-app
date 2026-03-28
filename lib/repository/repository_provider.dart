import 'package:dotto/api/api_client.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/lecture_cancellation_repository.dart';
import 'package:dotto/repository/personal_calendar_repository.dart';
import 'package:dotto/repository/room_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseRegistrationRepositoryProvider = Provider<CourseRegistrationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CourseRegistrationRepositoryImpl(apiClient);
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TimetableRepositoryImpl(apiClient);
});

final roomRepositoryProvider = Provider<RoomRepository>((_) => RoomRepositoryImpl());

final personalCalendarRepositoryProvider = Provider<PersonalCalendarRepository>(
  (_) => PersonalCalendarRepositoryImpl(),
);

final lectureCancellationRepositoryProvider = Provider<LectureCancellationRepository>(
  (_) => LectureCancellationRepositoryImpl(),
);
