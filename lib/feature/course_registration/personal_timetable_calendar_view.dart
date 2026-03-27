import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course_registration/personal_timetable_calendar_reducer.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class PersonalTimetableCalendarView extends HookConsumerWidget {
  const PersonalTimetableCalendarView({required this.onSubjectSelected, super.key});

  final void Function(SubjectSummary) onSubjectSelected;

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
      appBar: AppBar(title: const Text('時間割')),
      body: switch (state) {
        AsyncData(value: final days) => RefreshIndicator(
          onRefresh: () => ref.read(personalTimetableCalendarReducerProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _calendar(
                context,
                days: days,
                selectedDate: selectedDate.value ?? (days.isNotEmpty ? days.first.date : DateTime.now()),
                onDateSelected: (date) {
                  selectedDate.value = date;
                },
              ),
            ),
          ),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError() => const Center(child: Text('データの取得に失敗しました')),
      },
    );
  }

  Widget _calendar(
    BuildContext context, {
    required List<PersonalTimetableDay> days,
    required DateTime selectedDate,
    required void Function(DateTime) onDateSelected,
  }) {
    final firstWeekDates = days.take(5).map((e) => e.date).toList();
    final secondWeekDates = days.skip(5).take(5).map((e) => e.date).toList();
    final selectedCandidates = days.where((e) => _isSameDate(e.date, selectedDate));
    final selectedDay = selectedCandidates.isEmpty ? null : selectedCandidates.first;

    return Column(
      spacing: 8,
      children: [
        if (firstWeekDates.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: firstWeekDates
                .map(
                  (date) => SizedBox(
                    width: 48,
                    child: Center(
                      child: Text(
                        DateFormatter.dayOfWeek(date),
                        style: TextStyle(fontSize: 14, color: SemanticColor.light.labelPrimary),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        CarouselSlider(
          items: [
            _dateButtons(dates: firstWeekDates, selectedDate: selectedDate, onDateSelected: onDateSelected),
            _dateButtons(dates: secondWeekDates, selectedDate: selectedDate, onDateSelected: onDateSelected),
          ],
          options: CarouselOptions(height: 48, viewportFraction: 1, enableInfiniteScroll: false),
        ),
        _dayTimetable(context, selectedDay),
      ],
    );
  }

  Widget _dateButtons({
    required List<DateTime> dates,
    required DateTime selectedDate,
    required void Function(DateTime) onDateSelected,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: dates
          .map(
            (date) => _dateButton(
              date: date,
              isSelected: _isSameDate(selectedDate, date),
              onPressed: () => onDateSelected(date),
            ),
          )
          .toList(),
    );
  }

  Widget _dateButton({required DateTime date, required bool isSelected, required VoidCallback onPressed}) {
    return SizedBox(
      width: 48,
      height: 48,
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16),
          foregroundColor: isSelected ? SemanticColor.light.labelTertiary : SemanticColor.light.labelSecondary,
          backgroundColor: isSelected ? SemanticColor.light.accentPrimary : SemanticColor.light.backgroundSecondary,
          overlayColor: SemanticColor.light.accentPrimary,
          side: BorderSide(color: SemanticColor.light.borderPrimary),
          shape: const CircleBorder(),
          fixedSize: const Size(48, 48),
        ),
        onPressed: onPressed,
        child: Text(DateFormatter.dayOfMonth(date)),
      ),
    );
  }

  Widget _dayTimetable(BuildContext context, PersonalTimetableDay? selectedDay) {
    return Column(
      spacing: 4,
      children: Period.values
          .map(
            (period) => _periodRow(
              context,
              period: period,
              items: selectedDay?.items.where((item) => item.period == period).toList() ?? const [],
            ),
          )
          .toList(),
    );
  }

  Widget _periodRow(BuildContext context, {required Period period, required List<PersonalTimetableItem> items}) {
    return Row(
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            width: 24,
            child: Center(
              child: Text(
                period.number.toString(),
                style: TextStyle(fontSize: 20, color: SemanticColor.light.accentPrimary),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            spacing: 8,
            children: items.isEmpty
                ? [_itemButton(context, null)]
                : items.map((item) => _itemButton(context, item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _itemButton(BuildContext context, PersonalTimetableItem? item) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          backgroundColor: SemanticColor.light.backgroundSecondary,
          disabledBackgroundColor: SemanticColor.light.backgroundTertiary,
          overlayColor: SemanticColor.light.accentPrimary,
          side: BorderSide(color: SemanticColor.light.borderPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: item == null ? null : () => onSubjectSelected(item.subject),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: 8,
                children: [
                  Flexible(
                    child: Text(
                      item?.subject.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: SemanticColor.light.labelPrimary),
                    ),
                  ),
                  if (item != null) _lectureStatusLabel(item.lectureStatus),
                ],
              ),
            ),
            Text(item?.roomName ?? '', style: TextStyle(fontSize: 12, color: SemanticColor.light.labelSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _lectureStatusLabel(LectureStatus status) {
    return switch (status) {
      LectureStatus.cancelled => Row(
        spacing: 2,
        children: [
          Icon(Icons.cancel_outlined, size: 16, color: SemanticColor.light.accentError),
          Text('休講', style: TextStyle(color: SemanticColor.light.accentError)),
        ],
      ),
      LectureStatus.madeUp => Row(
        spacing: 2,
        children: [
          Icon(Icons.info_outline, size: 16, color: SemanticColor.light.accentWarning),
          Text('補講', style: TextStyle(color: SemanticColor.light.accentWarning)),
        ],
      ),
      LectureStatus.normal => const SizedBox.shrink(),
    };
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
