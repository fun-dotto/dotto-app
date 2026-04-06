import 'package:built_collection/built_collection.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/feature/course/course_cancellation_state.dart';
import 'package:dotto/repository/cancelled_class_repository.dart';
import 'package:dotto/repository/makeup_class_repository.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:dotto/repository/room_change_repository.dart';
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
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _createState(isFiltered: current?.isFiltered ?? false));
  }

  Future<void> toggleFilter() async {
    final current = state.value;
    final nextIsFiltered = !(current?.isFiltered ?? false);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _createState(isFiltered: nextIsFiltered));
  }

  Future<CourseCancellationState> _createState({required bool isFiltered}) async {
    final cancelledClassRepository = ref.read(cancelledClassRepositoryProvider);
    final makeupClassRepository = ref.read(makeupClassRepositoryProvider);
    final roomChangeRepository = ref.read(roomChangeRepositoryProvider);

    BuiltList<String>? subjectIds;
    if (isFiltered) {
      final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
      final courseRegistrations = await courseRegistrationRepository.getCourseRegistrations(Semester.values);
      subjectIds = BuiltList<String>(courseRegistrations.map((r) => r.subject.id));
    }

    final (cancelledClasses, makeupClasses, roomChanges) = await (
      cancelledClassRepository.getCancelledClasses(subjectIds: subjectIds),
      makeupClassRepository.getMakeupClasses(subjectIds: subjectIds),
      roomChangeRepository.getRoomChanges(subjectIds: subjectIds),
    ).wait;

    return CourseCancellationState(
      cancelledClasses: cancelledClasses.toList(),
      makeupClasses: makeupClasses.toList(),
      roomChanges: roomChanges.toList(),
      isFiltered: isFiltered,
    );
  }
}
