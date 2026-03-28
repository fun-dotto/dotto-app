import 'package:dotto/domain/lecture_override.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/helper/file_helper.dart';

abstract class LectureCancellationRepository {
  Future<LectureCancellationData> getLectureCancellationData();
}

final class LectureCancellationRepositoryImpl implements LectureCancellationRepository {
  LectureCancellationRepositoryImpl();

  @override
  Future<LectureCancellationData> getLectureCancellationData() async {
    final (cancelledByDate, madeUpByDate) = await (
      _loadLectureOverrides('home/cancel_lecture.json'),
      _loadLectureOverrides('home/sup_lecture.json'),
    ).wait;

    return LectureCancellationData(cancelledByDate: cancelledByDate, madeUpByDate: madeUpByDate);
  }

  Future<Map<String, List<LectureOverride>>> _loadLectureOverrides(String path) async {
    final data = await _loadJsonList(path);
    final result = <String, List<LectureOverride>>{};
    for (final row in data) {
      if (row is! Map<String, dynamic>) continue;
      final dateRaw = row['date'] as String?;
      final lessonName = row['lessonName'] as String?;
      final periodNumber = row['period'] as int?;
      if (dateRaw == null || lessonName == null || periodNumber == null) continue;
      final period = _toPeriod(periodNumber);
      if (period == null) continue;
      final date = DateTime.tryParse(dateRaw);
      if (date == null) continue;
      final dateKey = _formatDateKey(date);
      result
          .putIfAbsent(dateKey, () => <LectureOverride>[])
          .add(LectureOverride(lessonName: lessonName, period: period));
    }
    return result;
  }

  Future<List<dynamic>> _loadJsonList(String path) async {
    try {
      return await FileHelper.getJSONData(path);
    } on Exception {
      return const <dynamic>[];
    }
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Period? _toPeriod(int number) {
    if (number < 1 || number > Period.values.length) {
      return null;
    }
    return Period.fromNumber(number);
  }
}
