import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_slot.freezed.dart';

@freezed
abstract class TimetableSlot with _$TimetableSlot {
  const factory TimetableSlot({required DayOfWeek dayOfWeek, required Period period}) = _TimetableSlot;
}
