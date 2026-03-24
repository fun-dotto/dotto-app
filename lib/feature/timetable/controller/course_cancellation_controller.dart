import 'package:dotto/feature/timetable/controller/is_filtered_only_taking_course_cancellation_controller.dart';
import 'package:dotto/feature/timetable/domain/course_cancellation.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/helper/file_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_cancellation_controller.g.dart';

@riverpod
final class CourseCancellationNotifier extends _$CourseCancellationNotifier {
  @override
  Future<List<CourseCancellation>> build() async {
    final isFilteredOnlyTakingCourseCancellation = ref.watch(isFilteredOnlyTakingCourseCancellationProvider);
    final data = await FileHelper.getJSONData('home/cancel_lecture.json');
    final courseCancellations = data
        .map((dynamic item) => CourseCancellation.fromJson(item as Map<String, dynamic>))
        .toList();
    if (!isFilteredOnlyTakingCourseCancellation) {
      return courseCancellations;
    }
    final personalTimetableMap = await TimetableRepository().loadPersonalTimetableMapString();
    return courseCancellations.where((courseCancellation) {
      return personalTimetableMap.keys.contains(courseCancellation.lessonName);
    }).toList();
  }
}
