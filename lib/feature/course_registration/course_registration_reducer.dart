import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_semester.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_registration_reducer.g.dart';

@riverpod
final class CourseRegistrationReducer extends _$CourseRegistrationReducer {
  @override
  Future<List<TimetableItem>> build() async {
    return const [];
  }

  Future<void> refresh(TimetableSemester semester) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final apiClient = ref.read(apiClientProvider);
      final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);
      final timetableRepository = TimetableRepositoryImpl(apiClient);
      final semesters = semester.semesters;

      final (timetableItems, courseRegistrations) = await (
        timetableRepository.getTimetableItems(semesters),
        courseRegistrationRepository.getCourseRegistrations(semesters),
      ).wait;

      final registeredSubjectIds = courseRegistrations.map((e) => e.subject.id).toSet();
      return timetableItems
          .map((item) => item.copyWith(isAddedToTimetable: registeredSubjectIds.contains(item.subject.id)))
          .toList();
    });
  }
}
