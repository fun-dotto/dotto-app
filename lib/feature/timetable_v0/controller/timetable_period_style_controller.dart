import 'package:dotto/controller/dotto_user_preference_controller.dart';
import 'package:dotto/feature/timetable_v0/domain/timetable_period_style.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timetable_period_style_controller.g.dart';

@riverpod
final class TimetablePeriodStyleNotifier extends _$TimetablePeriodStyleNotifier {
  @override
  Future<TimetablePeriodStyle> build() async {
    final preference = await ref.watch(dottoUserPreferenceProvider.future);
    return preference.timetablePeriodStyle;
  }

  Future<void> setStyle(TimetablePeriodStyle style) async {
    await ref.read(dottoUserPreferenceProvider.notifier).setTimetablePeriodStyle(style);
    state = AsyncValue.data(style);
  }
}
