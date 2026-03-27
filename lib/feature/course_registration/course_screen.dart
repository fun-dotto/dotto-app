import 'dart:async';

import 'package:dotto/feature/course_registration/course_registration_screen.dart';
import 'package:dotto/feature/course_registration/personal_timetable_calendar_reducer.dart';
import 'package:dotto/feature/course_registration/personal_timetable_calendar_view.dart';
import 'package:dotto/feature/subject/search_subject_screen.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class CourseScreen extends HookConsumerWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalTimetableCalendarReducerProvider);
    final selectedDate = useState<DateTime?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(ref.read(personalTimetableCalendarReducerProvider.notifier).refresh());
      });
      return null;
    }, []);

    useEffect(() {
      final days = state.value;
      if (days == null || days.isEmpty) {
        return null;
      }
      if (selectedDate.value == null || !days.any((e) => _isSameDate(e.date, selectedDate.value!))) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final todayEntry = days.where((e) => _isSameDate(e.date, today));
        selectedDate.value = todayEntry.isNotEmpty ? todayEntry.first.date : days.first.date;
      }
      return null;
    }, [state]);

    return Scaffold(
      appBar: AppBar(title: const Text('講義'), centerTitle: false),
      body: switch (state) {
        AsyncData(value: final days) => RefreshIndicator(
          onRefresh: () => ref.read(personalTimetableCalendarReducerProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
                  child: PersonalTimetableCalendarView(
                    personalTimetableDays: days,
                    selectedDate: selectedDate.value,
                    onDateSelected: (newDate) => selectedDate.value = newDate,
                    onSubjectSelected: (subject) {
                      // TODO: Push navigation to SubjectDetailScreen
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: .end,
                  children: [
                    DottoButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const CourseRegistrationScreen(),
                          settings: const RouteSettings(name: '/course/registration'),
                        ),
                      ),
                      type: DottoButtonType.text,
                      child: const Text('1週間の時間割'),
                    ),
                  ],
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _featureButtons(context)),
              ],
            ),
          ),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError() => const Center(child: Text('データの取得に失敗しました')),
      },
    );
  }

  Widget _featureButtons(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: SemanticColor.light.borderPrimary),
        borderRadius: BorderRadius.circular(16),
        color: SemanticColor.light.backgroundSecondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: .center,
          spacing: 8,
          children: [
            _featureButton(
              context,
              icon: Icons.search,
              label: '科目検索',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SearchSubjectScreen(),
                  settings: const RouteSettings(name: '/course/subjects'),
                ),
              ),
            ),
            _featureButton(context, icon: Icons.calendar_month, label: '休講・補講', onPressed: null),
          ],
        ),
      ),
    );
  }

  Widget _featureButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 72,
      child: Column(
        spacing: 4,
        children: [
          IconButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: SemanticColor.light.labelPrimary,
              backgroundColor: SemanticColor.light.backgroundPrimary,
              shape: CircleBorder(side: BorderSide(color: SemanticColor.light.borderPrimary)),
              elevation: 0,
              minimumSize: const Size(48, 48),
              iconSize: 24,
            ),
            onPressed: onPressed,
            icon: Icon(icon),
          ),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
