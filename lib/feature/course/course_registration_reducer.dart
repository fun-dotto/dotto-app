import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_semester.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_registration_reducer.g.dart';

@riverpod
final class CourseRegistrationReducer extends _$CourseRegistrationReducer {
  @override
  Future<Map<TimetableSemester, List<TimetableItem>>> build() async {
    return _fetchTimetableItemsBySemester();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchTimetableItemsBySemester);
  }

  Future<Map<TimetableSemester, List<TimetableItem>>>
  _fetchTimetableItemsBySemester() async {
    final apiClient = ref.read(apiClientProvider);
    final courseRegistrationRepository = CourseRegistrationRepositoryImpl(
      apiClient,
    );
    final timetableRepository = TimetableRepositoryImpl(apiClient);
    final (timetableItemsBySemester, courseRegistrations) = await (
      Future.wait(
        TimetableSemester.values.map((semester) async {
          final timetableItems = await timetableRepository.getTimetableItems(
            semester.semesters,
          );
          return (semester, timetableItems);
        }),
      ),
      courseRegistrationRepository.getCourseRegistrations(Semester.values),
    ).wait;

    final registeredSubjectIds = courseRegistrations
        .map((e) => e.subject.id)
        .toSet();
    return {
      for (final (semester, timetableItems) in timetableItemsBySemester)
        semester: timetableItems
            .map(
              (item) => item.copyWith(
                isAddedToTimetable: registeredSubjectIds.contains(
                  item.subject.id,
                ),
              ),
            )
            .toList(),
    };
  }
}
