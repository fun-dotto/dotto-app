import 'package:dotto/domain/period.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_cancellation.freezed.dart';

enum CourseCancellationType {
  cancellation(label: '休講'),
  makeUp(label: '補講');

  const CourseCancellationType({required this.label});

  final String label;
}

@freezed
abstract class CourseCancellation with _$CourseCancellation {
  const factory CourseCancellation({
    required DateTime date,
    required Period period,
    required String lessonName,
    required String comment,
    required CourseCancellationType type,
    int? lessonId,
    String? campus,
    String? staff,
  }) = _CourseCancellation;
}
