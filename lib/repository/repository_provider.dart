import 'package:dotto/api/api_client.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/fcm_token_repository.dart';
import 'package:dotto/repository/personal_calendar_repository.dart';
import 'package:dotto/repository/room_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fcmTokenRepositoryProvider = Provider<FCMTokenRepository>(FCMTokenRepositoryImpl.new);

final courseRegistrationRepositoryProvider = Provider<CourseRegistrationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CourseRegistrationRepositoryImpl(apiClient);
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TimetableRepositoryImpl(apiClient);
});

final roomRepositoryProvider = Provider<RoomRepository>((_) => RoomRepositoryImpl());

final personalCalendarRepositoryProvider = Provider<PersonalCalendarRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PersonalCalendarRepositoryImpl(apiClient);
});
