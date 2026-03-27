import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/subject_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_subject_reducer.g.dart';

final courseRegistrationRepositoryProvider = Provider<CourseRegistrationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CourseRegistrationRepositoryImpl(apiClient);
});

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SubjectRepositoryImpl(apiClient);
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TimetableRepositoryImpl(apiClient);
});

@riverpod
final class SearchSubjectReducer extends _$SearchSubjectReducer {
  List<TimetableItem>? _cachedTimetableItems;

  @override
  Future<List<SubjectSummary>> build() async {
    return const [];
  }

  Future<void> search({required String query, required SubjectFilter filter}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
      final subjectRepository = ref.read(subjectRepositoryProvider);
      final timetableRepository = ref.read(timetableRepositoryProvider);

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

  Future<void> registerSubject(String subjectId) async {
    final previousSubjects = state.valueOrNull;
    if (previousSubjects == null) {
      return;
    }
    _updateSubjectRegistrationState(subjectId: subjectId, isAddedToTimetable: true);
    final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
    try {
      await courseRegistrationRepository.registerCourse(subjectId);
    } catch (_) {
      _restoreSubjects(previousSubjects);
      rethrow;
    }
  }

  Future<void> unregisterSubject(String subjectId) async {
    final previousSubjects = state.valueOrNull;
    if (previousSubjects == null) {
      return;
    }
    _updateSubjectRegistrationState(subjectId: subjectId, isAddedToTimetable: false);
    final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
    try {
      final courseRegistrations = await courseRegistrationRepository.getCourseRegistrations(Semester.values);
      final targets = courseRegistrations.where((registration) => registration.subject.id == subjectId);
      if (targets.isEmpty) {
        throw Exception('Failed to find course registration for subject: $subjectId');
      }
      await courseRegistrationRepository.unregisterCourse(targets.first.id);
    } catch (_) {
      _restoreSubjects(previousSubjects);
      rethrow;
    }
  }

  void _updateSubjectRegistrationState({required String subjectId, required bool isAddedToTimetable}) {
    final subjects = state.valueOrNull;
    if (subjects == null) {
      return;
    }
    state = AsyncData(
      subjects.map((subject) {
        if (subject.id != subjectId) {
          return subject;
        }
        return subject.copyWith(isAddedToTimetable: isAddedToTimetable);
      }).toList(),
    );
  }

  void _restoreSubjects(List<SubjectSummary> subjects) {
    state = AsyncData(subjects);
  }
}
