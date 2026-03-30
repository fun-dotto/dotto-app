import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class PersonalTimetableCalendarView extends HookWidget {
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
  Widget build(BuildContext context) {
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
      pageController.animateToPage(targetPage, duration: const Duration(milliseconds: 250), curve: Curves.easeOutCubic);
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
  }) {
    final firstWeekDates = days.take(5).map((e) => e.date).toList();
    final secondWeekDates = days.skip(5).take(5).map((e) => e.date).toList();
    final clampedPage = days.isEmpty ? 0 : currentPage.clamp(0, days.length - 1).toInt();
    final currentDay = days.isEmpty ? null : days[clampedPage];
    final timetableHeight = currentDay == null ? 0.0 : _dayTimetableHeight(currentDay);

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
                itemBuilder: (context, index) => _dayTimetable(context, days[index]),
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
