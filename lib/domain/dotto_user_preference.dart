import 'package:dotto/feature/timetable_v0/domain/timetable_period_style.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dotto_user_preference.freezed.dart';

@freezed
abstract class DottoUserPreference with _$DottoUserPreference {
  const factory DottoUserPreference({
    @Default(TimetablePeriodStyle.numberOnly) TimetablePeriodStyle timetablePeriodStyle,
  }) = _DottoUserPreference;
}
