import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/subject_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchSubjectReducerProvider = AutoDisposeAsyncNotifierProvider<SearchSubjectReducer, List<SubjectSummary>>(
  SearchSubjectReducer.new,
);

final class SearchSubjectReducer extends AutoDisposeAsyncNotifier<List<SubjectSummary>> {
  List<TimetableItem>? _cachedTimetableItems;

  @override
  Future<List<SubjectSummary>> build() async {
    return const [];
  }

  Future<void> search({required String query, required SubjectFilter filter}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final apiClient = ref.read(apiClientProvider);
      final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);
      final subjectRepository = SubjectRepositoryImpl(apiClient);
      final timetableRepository = TimetableRepositoryImpl(apiClient);

      var timetableItems = _cachedTimetableItems;
      if (timetableItems == null) {
        timetableItems = await timetableRepository.getTimetableItems(Semester.values);
        _cachedTimetableItems = timetableItems;
      }

      final courseRegistrationsFuture = courseRegistrationRepository.getCourseRegistrations(Semester.values);
      final subjectsFuture = subjectRepository.getSubjects(query, filter);

      final courseRegistrations = await courseRegistrationsFuture;
      final subjects = await subjectsFuture;

      final registeredSubjectIds = courseRegistrations.map((e) => e.subject.id).toSet();
      final timetableSlotsBySubjectId = {
        for (final item in timetableItems)
          if (item.subject.slot != null) item.subject.id: item.subject.slot,
      };

      return BuiltList<SubjectSummary>(
        subjects.map((subject) {
          return subject.copyWith(
            slot: timetableSlotsBySubjectId[subject.id],
            isAddedToTimetable: registeredSubjectIds.contains(subject.id),
          );
        }),
      ).toList();
    });
  }
}
