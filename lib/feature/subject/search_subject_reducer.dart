import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:dotto/feature/subject/search_subject_state.dart';
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
  int _latestSearchRequestId = 0;

  @override
  Future<SearchSubjectState> build() async {
    return const SearchSubjectState();
  }

  Future<void> search({
    required String query,
    required SubjectFilter filter,
  }) async {
    final requestId = ++_latestSearchRequestId;
    final previousAsyncState = state;
    final previousState = state.hasValue
        ? state.requireValue
        : const SearchSubjectState();
    state = const AsyncLoading<SearchSubjectState>().copyWithPrevious(
      previousAsyncState,
      isRefresh: false,
    );

    try {
      final isAuthenticated = ref.read(isAuthenticatedProvider);
      final courseRegistrationRepository = ref.read(
        courseRegistrationRepositoryProvider,
      );
      final subjectRepository = ref.read(subjectRepositoryProvider);
      final timetableRepository = ref.read(timetableRepositoryProvider);

      final Future<List<CourseRegistration>> courseRegistrationsFuture =
          isAuthenticated
          ? courseRegistrationRepository.getCourseRegistrations(Semester.values)
          : Future.value(const <CourseRegistration>[]);
      final subjectsFuture = subjectRepository.getSubjects(query, filter);

      var timetableItems = _cachedTimetableItems;
      if (timetableItems == null) {
        timetableItems = await timetableRepository.getTimetableItems(
          Semester.values,
        );
        _cachedTimetableItems = timetableItems;
      }

      final courseRegistrations = await courseRegistrationsFuture;
      final fetchedSubjects = await subjectsFuture;

      final registeredSubjectIds = courseRegistrations
          .map((e) => e.subject.id)
          .toSet();
      final timetableSlotsBySubjectId = <String, List<TimetableSlot>>{};
      for (final item in timetableItems) {
        final slot = item.slot;
        if (slot == null) {
          continue;
        }
        timetableSlotsBySubjectId
            .putIfAbsent(item.subject.id, () => [])
            .add(slot);
      }

      final mergedSubjects = BuiltList<SubjectSummary>(
        fetchedSubjects.map((subject) {
          return subject.copyWith(
            slots: timetableSlotsBySubjectId[subject.id],
            isAddedToTimetable: registeredSubjectIds.contains(subject.id),
          );
        }),
      ).toList();

      if (!ref.mounted || requestId != _latestSearchRequestId) {
        return;
      }

      state = AsyncData(
        previousState.copyWith(subjects: mergedSubjects, filter: filter),
      );
    } catch (error, stackTrace) {
      if (!ref.mounted || requestId != _latestSearchRequestId) {
        return;
      }

      state = AsyncError<SearchSubjectState>(
        error,
        stackTrace,
      ).copyWithPrevious(previousAsyncState);
    }
  }

  void updateFilter(SubjectFilter filter) {
    final currentState = state.asData?.value ?? const SearchSubjectState();
    state = AsyncData(currentState.copyWith(filter: filter));
  }

  Future<void> registerSubject(String subjectId) async {
    final currentState = state.asData?.value;
    if (currentState != null) {
      final subject = currentState.subjects
          .where((s) => s.id == subjectId)
          .firstOrNull;
      final slots = subject?.slots;
      if (slots != null && slots.isNotEmpty) {
        final timetableRepository = ref.read(timetableRepositoryProvider);
        final timetableItems = await timetableRepository.getTimetableItems(
          Semester.values,
        );
        _cachedTimetableItems = timetableItems;

        final courseRegistrationRepository = ref.read(
          courseRegistrationRepositoryProvider,
        );
        final courseRegistrations = await courseRegistrationRepository
            .getCourseRegistrations(Semester.values);
        final registeredSubjectIds = courseRegistrations
            .map((e) => e.subject.id)
            .toSet();

        for (final slot in slots) {
          final registeredCount = timetableItems
              .where(
                (item) =>
                    item.slot?.dayOfWeek == slot.dayOfWeek &&
                    item.slot?.period == slot.period &&
                    registeredSubjectIds.contains(item.subject.id),
              )
              .length;
          if (registeredCount >= 2) {
            throw Exception('1つのコマに2科目以上を設定できません');
          }
        }
      }
    }

    final courseRegistrationRepository = ref.read(
      courseRegistrationRepositoryProvider,
    );
    await courseRegistrationRepository.registerCourse(subjectId);
    _cachedTimetableItems = null;
    _updateSubjectRegistrationState(
      subjectId: subjectId,
      isAddedToTimetable: true,
    );
  }

  Future<void> unregisterSubject(String subjectId) async {
    if (!ref.read(isAuthenticatedProvider)) {
      return;
    }
    final courseRegistrationRepository = ref.read(
      courseRegistrationRepositoryProvider,
    );
    final courseRegistrations = await courseRegistrationRepository
        .getCourseRegistrations(Semester.values);
    final targets = courseRegistrations.where(
      (registration) => registration.subject.id == subjectId,
    );
    if (targets.isEmpty) {
      return;
    }
    await courseRegistrationRepository.unregisterCourse(targets.first.id);
    _updateSubjectRegistrationState(
      subjectId: subjectId,
      isAddedToTimetable: false,
    );
  }

  void clearResults() {
    final currentState = state.asData?.value ?? const SearchSubjectState();
    state = AsyncData(currentState.copyWith(subjects: const []));
  }

  void clearFilter() {
    final currentState = state.asData?.value ?? const SearchSubjectState();
    state = AsyncData(currentState.copyWith(filter: SubjectFilter()));
  }

  void _updateSubjectRegistrationState({
    required String subjectId,
    required bool isAddedToTimetable,
  }) {
    final currentState = state.asData?.value;
    if (currentState == null) {
      return;
    }
    state = AsyncData(
      currentState.copyWith(
        subjects: currentState.subjects.map((subject) {
          if (subject.id != subjectId) {
            return subject;
          }
          return subject.copyWith(isAddedToTimetable: isAddedToTimetable);
        }).toList(),
      ),
    );
  }
}
