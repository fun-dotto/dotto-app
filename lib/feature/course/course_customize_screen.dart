import 'package:dotto/controller/dotto_user_preference_controller.dart';
import 'package:dotto/domain/timetable_period_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class CourseCustomizeScreen extends ConsumerWidget {
  const CourseCustomizeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreference = ref.watch(dottoUserPreferenceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('カスタム')),
      body: switch (userPreference) {
        AsyncData(value: final preference) => SwitchListTile(
          title: const Text('時間割に時刻を表示'),
          value:
              preference.timetablePeriodStyle ==
              TimetablePeriodStyle.numberAndTime,
          onChanged: (value) {
            ref
                .read(dottoUserPreferenceProvider.notifier)
                .setTimetablePeriodStyle(
                  value
                      ? TimetablePeriodStyle.numberAndTime
                      : TimetablePeriodStyle.numberOnly,
                );
          },
        ),
        AsyncError() => const Center(child: Text('ユーザー設定の読み込みに失敗しました')),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
