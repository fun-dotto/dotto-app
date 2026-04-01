import 'package:dotto/controller/dotto_user_preference_controller.dart';
import 'package:dotto/feature/timetable_v0/domain/timetable_period_style.dart';
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
        AsyncData(value: final preference) => ListView(
          children: [
            const ListTile(title: Text('時間割の時限表示')),
            ...TimetablePeriodStyle.values.map(
              (style) => RadioListTile<TimetablePeriodStyle>(
                title: Text(style.label),
                value: style,
                groupValue: preference.timetablePeriodStyle,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  ref.read(dottoUserPreferenceProvider.notifier).setTimetablePeriodStyle(value);
                },
              ),
            ),
          ],
        ),
        AsyncError() => const Center(child: Text('ユーザー設定の読み込みに失敗しました')),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
