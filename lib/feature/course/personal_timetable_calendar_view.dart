import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotto/controller/dotto_user_preference_controller.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_period_style.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class PersonalTimetableCalendarView extends HookConsumerWidget {
  const PersonalTimetableCalendarView({
    required this.personalTimetableDays,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onSubjectSelected,
    super.key,
  });

  final List<PersonalTimetableDay> personalTimetableDays;
  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;
  final void Function(SubjectSummary) onSubjectSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreference = ref.watch(dottoUserPreferenceProvider);
    final isTimetableTimeVisible = switch (userPreference) {
      AsyncData(value: final preference) => preference.timetablePeriodStyle == TimetablePeriodStyle.numberAndTime,
      AsyncError() || AsyncLoading() => false,
    };
    final safeSelectedDate =
        selectedDate ?? (personalTimetableDays.isNotEmpty ? personalTimetableDays.first.date : DateTime.now());
    final selectedDayIndex = personalTimetableDays.indexWhere((day) => _isSameDate(day.date, safeSelectedDate));
    final initialPage = selectedDayIndex >= 0 ? selectedDayIndex : 0;
    final currentPage = useState(initialPage);
    final pageController = usePageController(initialPage: initialPage);

    useEffect(() {
      if (personalTimetableDays.isEmpty) {
        return null;
      }
      final lastPageIndex = personalTimetableDays.length - 1;
      if (currentPage.value > lastPageIndex && pageController.hasClients) {
        currentPage.value = lastPageIndex;
        pageController.jumpToPage(lastPageIndex);
      }
      final targetPage = personalTimetableDays.indexWhere((day) => _isSameDate(day.date, safeSelectedDate));
      if (targetPage < 0 || targetPage == currentPage.value || !pageController.hasClients) {
        return null;
      }
      unawaited(
        pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        ),
      );
      return null;
    }, [personalTimetableDays, safeSelectedDate, pageController]);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: _calendar(
        context,
        days: personalTimetableDays,
        selectedDate: safeSelectedDate,
        currentPage: currentPage.value,
        onPageChanged: (newPage) => currentPage.value = newPage,
        pageController: pageController,
        onDateSelected: onDateSelected,
        isTimetableTimeVisible: isTimetableTimeVisible,
      ),
    );
  }

  Widget _calendar(
    BuildContext context, {
    required List<PersonalTimetableDay> days,
    required DateTime selectedDate,
    required int currentPage,
    required void Function(int) onPageChanged,
    required PageController pageController,
    required void Function(DateTime) onDateSelected,
    required bool isTimetableTimeVisible,
  }) {
    // 5日ずつ週に分割
    final datePages = <List<DateTime>>[];
    for (var i = 0; i < days.length; i += 5) {
      final end = (i + 5).clamp(0, days.length);
      datePages.add(days.sublist(i, end).map((e) => e.date).toList());
    }
    final clampedPage = days.isEmpty ? 0 : currentPage.clamp(0, days.length - 1);
    final dateCarouselInitialPage = datePages.isEmpty ? 0 : (clampedPage ~/ 5).clamp(0, datePages.length - 1);
    final currentDay = days.isEmpty ? null : days[clampedPage];
    final displayWeekDates = datePages.isEmpty ? <DateTime>[] : datePages[dateCarouselInitialPage];
    final timetableHeight = currentDay == null ? 0.0 : _dayTimetableHeight(currentDay);

    return Column(
      spacing: 8,
      children: [
        if (displayWeekDates.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: displayWeekDates
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
          key: ValueKey(dateCarouselInitialPage),
          items: datePages
              .map((dates) => _dateButtons(dates: dates, selectedDate: selectedDate, onDateSelected: onDateSelected))
              .toList(),
          options: CarouselOptions(
            height: 48,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            initialPage: dateCarouselInitialPage,
            onPageChanged: (index, _) {
              final pageDates = datePages[index];
              if (pageDates.isEmpty || pageDates.any((date) => _isSameDate(date, selectedDate))) {
                return;
              }
              onDateSelected(pageDates.first);
            },
          ),
        ),
        if (currentDay != null)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: timetableHeight,
              child: PageView.builder(
                controller: pageController,
                itemCount: days.length,
                onPageChanged: (index) {
                  onPageChanged(index);
                  onDateSelected(days[index].date);
                },
                itemBuilder: (context, index) {
                  return _dayTimetable(context, days[index], isTimetableTimeVisible: isTimetableTimeVisible);
                },
              ),
            ),
          ),
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

  Widget _dayTimetable(
    BuildContext context,
    PersonalTimetableDay? selectedDay, {
    required bool isTimetableTimeVisible,
  }) {
    return Column(
      spacing: 4,
      children: Period.values
          .map(
            (period) => _periodRow(
              context,
              period: period,
              items: selectedDay?.items.where((item) => item.period == period).toList() ?? const [],
              isTimetableTimeVisible: isTimetableTimeVisible,
            ),
          )
          .toList(),
    );
  }

  double _dayTimetableHeight(PersonalTimetableDay day) {
    // TextButton keeps at least 48dp tap target height by default.
    const itemButtonHeight = kMinInteractiveDimension;
    const itemSpacing = 8.0;
    const periodSpacing = 4.0;

    final totalRowHeight = Period.values
        .map((period) {
          final itemCount = day.items.where((item) => item.period == period).length;
          final visibleItemCount = itemCount == 0 ? 1 : itemCount;
          return (visibleItemCount * itemButtonHeight) + ((visibleItemCount - 1) * itemSpacing);
        })
        .fold<double>(0, (sum, rowHeight) => sum + rowHeight);
    final rowGap = (Period.values.length - 1) * periodSpacing;
    return totalRowHeight + rowGap;
  }

  Widget _periodRow(
    BuildContext context, {
    required Period period,
    required List<PersonalTimetableItem> items,
    required bool isTimetableTimeVisible,
  }) {
    final visibleItemCount = items.isEmpty ? 1 : items.length;
    final periodRowHeight = (visibleItemCount * kMinInteractiveDimension) + ((visibleItemCount - 1) * 8);

    return Row(
      spacing: 4,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            width: isTimetableTimeVisible ? 56 : 24,
            child: SizedBox(
              height: periodRowHeight,
              child: Row(
                mainAxisAlignment: isTimetableTimeVisible ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    period.number.toString(),
                    style: TextStyle(fontSize: 20, color: SemanticColor.light.accentPrimary),
                  ),
                  if (isTimetableTimeVisible)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(period.startTime),
                            textAlign: TextAlign.right,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall!.copyWith(color: SemanticColor.light.accentPrimary),
                          ),
                          Text(
                            '|',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall!.copyWith(color: SemanticColor.light.accentPrimary, fontSize: 4),
                          ),
                          Text(
                            _formatTime(period.endTime),
                            textAlign: TextAlign.right,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall!.copyWith(color: SemanticColor.light.accentPrimary),
                          ),
                        ],
                      ),
                    ),
                ],
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
