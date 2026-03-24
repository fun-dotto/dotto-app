import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_feedback.freezed.dart';

@freezed
abstract class SubjectFeedback with _$SubjectFeedback {
  factory SubjectFeedback({required int score, required String comment}) = _SubjectFeedback;
}
