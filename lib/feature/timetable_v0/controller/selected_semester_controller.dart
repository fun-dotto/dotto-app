import 'package:dotto/domain/timetable_semester.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_semester_controller.g.dart';

@riverpod
final class SelectedSemesterNotifier extends _$SelectedSemesterNotifier {
  @override
  TimetableSemester build() {
    final now = DateTime.now();
    if ((now.month >= 9) || (now.month <= 2)) {
      return TimetableSemester.fall;
    }
    return TimetableSemester.spring;
  }

  TimetableSemester get value => state;

  set value(TimetableSemester newValue) {
    state = newValue;
  }
}
