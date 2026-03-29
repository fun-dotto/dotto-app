import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:dotto/repository/subject_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_subject_reducer.g.dart';

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SubjectRepositoryImpl(apiClient);
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
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      if (!isAuthenticated) {
        return const <SubjectSummary>[];
      }
      final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
      final subjectRepository = ref.read(subjectRepositoryProvider);
      final timetableRepository = ref.read(timetableRepositoryProvider);

      final Future<List<CourseRegistration>> courseRegistrationsFuture = isAuthenticated
          ? courseRegistrationRepository.getCourseRegistrations(Semester.values)
          : Future.value(const <CourseRegistration>[]);
      final subjectsFuture = subjectRepository.getSubjects(query, filter);

      var timetableItems = _cachedTimetableItems;
      if (timetableItems == null) {
        timetableItems = await timetableRepository.getTimetableItems(Semester.values);
        _cachedTimetableItems = timetableItems;
      }

      final courseRegistrations = await courseRegistrationsFuture;
      final subjects = await subjectsFuture;

      final registeredSubjectIds = courseRegistrations.map((e) => e.subject.id).toSet();
      final timetableSlotsBySubjectId = <String, List<TimetableSlot>>{};
      for (final item in timetableItems) {
        final slot = item.slot;
        if (slot == null) {
          continue;
        }
        timetableSlotsBySubjectId.putIfAbsent(item.subject.id, () => []).add(slot);
      }

      return BuiltList<SubjectSummary>(
        subjects.map((subject) {
          return subject.copyWith(
            slots: timetableSlotsBySubjectId[subject.id],
            isAddedToTimetable: registeredSubjectIds.contains(subject.id),
          );
        }),
      ).toList();
    });
  }

  Future<void> registerSubject(String subjectId) async {
    if (!ref.read(isAuthenticatedProvider)) {
      return;
    }
    final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
    await courseRegistrationRepository.registerCourse(subjectId);
    _updateSubjectRegistrationState(subjectId: subjectId, isAddedToTimetable: true);
  }

  Future<void> unregisterSubject(String subjectId) async {
    if (!ref.read(isAuthenticatedProvider)) {
      return;
    }
    final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
    final courseRegistrations = await courseRegistrationRepository.getCourseRegistrations(Semester.values);
    final targets = courseRegistrations.where((registration) => registration.subject.id == subjectId);
    if (targets.isEmpty) {
      return;
    }
    await courseRegistrationRepository.unregisterCourse(targets.first.id);
    _updateSubjectRegistrationState(subjectId: subjectId, isAddedToTimetable: false);
  }

  void _updateSubjectRegistrationState({required String subjectId, required bool isAddedToTimetable}) {
    final subjects = state.asData?.value;
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
}
