import 'package:dotto/domain/period.dart';

final class LectureOverride {
  LectureOverride({required this.lessonName, required this.period});

  final String lessonName;
  final Period period;
}

final class LectureCancellationData {
  LectureCancellationData({
    required this.cancelledByDate,
    required this.madeUpByDate,
  });

  final Map<String, List<LectureOverride>> cancelledByDate;
  final Map<String, List<LectureOverride>> madeUpByDate;
}
