import 'package:dotto/domain/dotto_user_preference.dart';
import 'package:dotto/domain/timetable_period_style.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dotto_user_preference_controller.g.dart';

@riverpod
final class DottoUserPreferenceNotifier extends _$DottoUserPreferenceNotifier {
  @override
  Future<DottoUserPreference> build() async {
    final timetablePeriodStyleKey = await UserPreferenceRepository.getString(
      UserPreferenceKeys.timetablePeriodStyle,
    );
    final timetablePeriodStyle =
        TimetablePeriodStyle.fromKey(
          timetablePeriodStyleKey ?? TimetablePeriodStyle.numberOnly.key,
        ) ??
        TimetablePeriodStyle.numberOnly;
    return DottoUserPreference(timetablePeriodStyle: timetablePeriodStyle);
  }

  Future<void> setTimetablePeriodStyle(
    TimetablePeriodStyle timetablePeriodStyle,
  ) async {
    final currentPreference = switch (state) {
      AsyncData(value: final preference) => preference,
      AsyncError() || AsyncLoading() => const DottoUserPreference(),
    };
    state = AsyncValue.data(
      currentPreference.copyWith(timetablePeriodStyle: timetablePeriodStyle),
    );
    await UserPreferenceRepository.setString(
      UserPreferenceKeys.timetablePeriodStyle,
      timetablePeriodStyle.key,
    );
  }
}
