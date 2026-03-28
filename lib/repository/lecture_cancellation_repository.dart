import 'package:dotto/domain/course_cancellation.dart';
import 'package:dotto/domain/lecture_override.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/helper/file_helper.dart';

abstract class LectureCancellationRepository {
  Future<LectureCancellationData> getLectureCancellationData();
  Future<List<CourseCancellation>> getCourseCancellations();
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

  @override
  Future<List<CourseCancellation>> getCourseCancellations() async {
    final (cancelledRows, madeUpRows) = await (
      _loadLectureCancellationRows('home/cancel_lecture.json'),
      _loadLectureCancellationRows('home/sup_lecture.json'),
    ).wait;

    final rows =
        [
          ...cancelledRows.map((row) => (row, CourseCancellationType.cancellation)),
          ...madeUpRows.map((row) => (row, CourseCancellationType.makeUp)),
        ]..sort((a, b) {
          final date = a.$1.date.compareTo(b.$1.date);
          if (date != 0) return date;
          final period = a.$1.period.number.compareTo(b.$1.period.number);
          if (period != 0) return period;
          return a.$2.index.compareTo(b.$2.index);
        });

    return rows
        .map(
          (entry) => CourseCancellation(
            date: entry.$1.date,
            period: entry.$1.period,
            lessonName: entry.$1.lessonName,
            comment: entry.$1.comment,
            type: entry.$2,
            lessonId: entry.$1.lessonId,
            campus: entry.$1.campus,
            staff: entry.$1.staff,
          ),
        )
        .toList();
  }

  Future<Map<String, List<LectureOverride>>> _loadLectureOverrides(String path) async {
    final result = <String, List<LectureOverride>>{};
    final rows = await _loadLectureCancellationRows(path);
    for (final row in rows) {
      final dateKey = _formatDateKey(row.date);
      result
          .putIfAbsent(dateKey, () => <LectureOverride>[])
          .add(LectureOverride(lessonName: row.lessonName, period: row.period));
    }
    return result;
  }

  Future<List<_LectureCancellationRow>> _loadLectureCancellationRows(String path) async {
    final data = await _loadJsonList(path);
    final rows = <_LectureCancellationRow>[];
    for (final row in data) {
      if (row is! Map<String, dynamic>) continue;
      final dateRaw = row['date'] as String?;
      final lessonName = row['lessonName'] as String?;
      final period = _toPeriod(row['period']);
      if (dateRaw == null || lessonName == null || period == null) continue;
      final date = DateTime.tryParse(dateRaw);
      if (date == null) continue;
      rows.add(
        _LectureCancellationRow(
          date: date,
          period: period,
          lessonName: lessonName,
          comment: (row['comment'] as String?) ?? '',
          lessonId: _toInt(row['lessonId']),
          campus: row['campus'] as String?,
          staff: row['staff'] as String?,
        ),
      );
    }
    return rows;
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

  Period? _toPeriod(Object? rawNumber) {
    final number = _toInt(rawNumber);
    if (number == null) return null;
    if (number < 1 || number > Period.values.length) {
      return null;
    }
    return Period.fromNumber(number);
  }

  int? _toInt(Object? value) {
    return switch (value) {
      int number => number,
      String text => int.tryParse(text),
      _ => null,
    };
  }
}

final class _LectureCancellationRow {
  _LectureCancellationRow({
    required this.date,
    required this.period,
    required this.lessonName,
    required this.comment,
    required this.lessonId,
    required this.campus,
    required this.staff,
  });

  final DateTime date;
  final Period period;
  final String lessonName;
  final String comment;
  final int? lessonId;
  final String? campus;
  final String? staff;
}
