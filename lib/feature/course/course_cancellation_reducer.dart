import 'package:dotto/domain/semester.dart';
import 'package:dotto/feature/course/course_cancellation_state.dart';
import 'package:dotto/repository/cancelled_class_repository.dart';
import 'package:dotto/repository/makeup_class_repository.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:dotto/repository/room_change_repository.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_cancellation_reducer.g.dart';

@riverpod
final class CourseCancellationReducer extends _$CourseCancellationReducer {
  @override
  Future<CourseCancellationState> build() async {
    return _createState(isFiltered: false);
  }

  Future<void> refresh() async {
    final current = state.value;
    state = await AsyncValue.guard(() => _createState(isFiltered: current?.isFiltered ?? false));
  }

  Future<void> toggleFilter() async {
    final current = state.value;
    if (current == null) {
      await refresh();
      return;
    }

    final nextIsFiltered = !current.isFiltered;
    state = AsyncData(
      current.copyWith(
        cancelledClasses: nextIsFiltered
            ? _filterCancelledClasses(current.allCancelledClasses, current.takingSubjectIds)
            : current.allCancelledClasses,
        makeupClasses: nextIsFiltered
            ? _filterMakeupClasses(current.allMakeupClasses, current.takingSubjectIds)
            : current.allMakeupClasses,
        roomChanges: nextIsFiltered
            ? _filterRoomChanges(current.allRoomChanges, current.takingSubjectIds)
            : current.allRoomChanges,
        isFiltered: nextIsFiltered,
      ),
    );
  }

  Future<CourseCancellationState> _createState({required bool isFiltered}) async {
    final cancelledClassRepository = ref.read(cancelledClassRepositoryProvider);
    final makeupClassRepository = ref.read(makeupClassRepositoryProvider);
    final roomChangeRepository = ref.read(roomChangeRepositoryProvider);
    final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);

    final (allCancelledClasses, allMakeupClasses, allRoomChanges, courseRegistrations) = await (
      cancelledClassRepository.getCancelledClasses(),
      makeupClassRepository.getMakeupClasses(),
      roomChangeRepository.getRoomChanges(),
      courseRegistrationRepository.getCourseRegistrations(Semester.values),
    ).wait;

    final takingSubjectIds = {for (final registration in courseRegistrations) registration.subject.id};

    return CourseCancellationState(
      cancelledClasses: isFiltered
          ? _filterCancelledClasses(allCancelledClasses.toList(), takingSubjectIds)
          : allCancelledClasses.toList(),
      allCancelledClasses: allCancelledClasses.toList(),
      makeupClasses: isFiltered
          ? _filterMakeupClasses(allMakeupClasses.toList(), takingSubjectIds)
          : allMakeupClasses.toList(),
      allMakeupClasses: allMakeupClasses.toList(),
      roomChanges: isFiltered ? _filterRoomChanges(allRoomChanges.toList(), takingSubjectIds) : allRoomChanges.toList(),
      allRoomChanges: allRoomChanges.toList(),
      takingSubjectIds: takingSubjectIds,
      isFiltered: isFiltered,
    );
  }

  List<CancelledClass> _filterCancelledClasses(List<CancelledClass> classes, Set<String> subjectIds) {
    return classes.where((c) => subjectIds.contains(c.subject.id)).toList();
  }

  List<MakeupClass> _filterMakeupClasses(List<MakeupClass> classes, Set<String> subjectIds) {
    return classes.where((c) => subjectIds.contains(c.subject.id)).toList();
  }

  List<RoomChange> _filterRoomChanges(List<RoomChange> changes, Set<String> subjectIds) {
    return changes.where((c) => subjectIds.contains(c.subject.id)).toList();
  }
}
