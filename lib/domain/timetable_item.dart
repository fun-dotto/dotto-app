import 'package:dotto/domain/subject_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_item.freezed.dart';

@freezed
abstract class TimetableItem with _$TimetableItem {
  const factory TimetableItem({required String id, required SubjectSummary subject}) = _TimetableItem;
}
