import 'dart:async';

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/quick_link.dart';
import 'package:dotto/feature/course/course_cancellation_screen.dart';
import 'package:dotto/feature/course/course_registration_screen.dart';
import 'package:dotto/feature/course/course_reducer.dart';
import 'package:dotto/feature/course/course_state.dart';
import 'package:dotto/feature/course/personal_timetable_calendar_view.dart';
import 'package:dotto/feature/subject/search_subject_screen.dart';
import 'package:dotto/feature/subject/subject_detail_screen.dart';
import 'package:dotto/widget/web_pdf_viewer.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class CourseScreen extends HookConsumerWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    // final timetablePeriodStyle = ref.watch(timetablePeriodStyleProvider);
    final quickLinksByLabel = {for (final link in QuickLink.links) link.label: link};
    final state = isAuthenticated ? ref.watch(courseReducerProvider) : const AsyncData(CourseState());
    final selectedDate = useState<DateTime?>(null);

    useEffect(() {
      if (!isAuthenticated) {
        return null;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted || !isAuthenticated) {
          return;
        }
        unawaited(ref.read(courseReducerProvider.notifier).refresh());
      });
      return null;
    }, [isAuthenticated]);

    useEffect(() {
      final days = state.value?.days;
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
        AsyncData(value: final courseState) => LayoutBuilder(
          builder: (context, constraints) => RefreshIndicator(
            onRefresh: () async {
              if (!isAuthenticated) {
                return;
              }
              await ref.read(courseReducerProvider.notifier).refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    if (isAuthenticated)
                      Padding(
                        padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
                        child: PersonalTimetableCalendarView(
                          personalTimetableDays: courseState.days,
                          selectedDate: selectedDate.value,
                          onDateSelected: (newDate) => selectedDate.value = newDate,
                          onSubjectSelected: (subject) => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => SubjectDetailScreen(id: subject.id),
                              settings: RouteSettings(name: '/course/subjects/${subject.id}'),
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
                        child: Center(
                          child: Text('時間割機能を利用するにはログインしてください。', style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ),
                    if (isAuthenticated)
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
                    Padding(
                      padding: const EdgeInsetsGeometry.all(16),
                      child: _shortcutSections(
                        context,
                        isAuthenticated: isAuthenticated,
                        quickLinksByLabel: quickLinksByLabel,
                        fileItems: [
                          ('学年暦', config.officialCalendarPdfUrl, Icons.event_note),
                          ('時間割 前期', config.timetable1PdfUrl, Icons.calendar_month),
                          ('時間割 後期', config.timetable2PdfUrl, Icons.calendar_month),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError() => RefreshIndicator(
          onRefresh: () async {
            if (!isAuthenticated) {
              return;
            }
            await ref.read(courseReducerProvider.notifier).refresh();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: const Center(child: Text('データの取得に失敗しました')),
              ),
            ],
          ),
        ),
      },
    );
  }

  Widget _shortcutSections(
    BuildContext context, {
    required bool isAuthenticated,
    required Map<String, QuickLink> quickLinksByLabel,
    required List<(String label, String url, IconData icon)> fileItems,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: SemanticColor.light.borderPrimary),
        borderRadius: BorderRadius.circular(16),
        color: SemanticColor.light.backgroundSecondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            _shortcutSection(
              context,
              title: '科目',
              items: [
                _ShortcutItem(
                  icon: Icons.search,
                  label: '科目検索',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const SearchSubjectScreen(),
                      settings: const RouteSettings(name: '/course/subjects'),
                    ),
                  ),
                ),
                if (isAuthenticated)
                  _ShortcutItem(
                    icon: Icons.calendar_month,
                    label: '休講・補講',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const CourseCancellationScreen(),
                        settings: const RouteSettings(name: '/course/cancellations'),
                      ),
                    ),
                  ),
              ],
            ),
            _shortcutSection(
              context,
              title: '時間割',
              items: fileItems
                  .map(
                    (item) => _ShortcutItem(
                      icon: item.$3,
                      label: item.$1,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => WebPdfViewer(url: item.$2, filename: item.$1),
                          settings: RouteSettings(name: '/home/web_pdf_viewer?url=${item.$2}'),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            _shortcutSection(
              context,
              title: 'ポータル',
              items: [
                if (quickLinksByLabel['HOPE'] case final hope?)
                  _ShortcutItem(
                    icon: Icons.school,
                    label: hope.label,
                    onPressed: () => launchUrlString(hope.url, mode: LaunchMode.externalApplication),
                  ),
                if (quickLinksByLabel['学生ポータル'] case final portal?)
                  _ShortcutItem(
                    icon: Icons.open_in_new,
                    label: portal.label,
                    onPressed: () => launchUrlString(portal.url, mode: LaunchMode.externalApplication),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shortcutSection(BuildContext context, {required String title, required List<_ShortcutItem> items}) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) => _shortcutButton(context, item: items[index]),
        ),
      ],
    );
  }

  Widget _shortcutButton(BuildContext context, {required _ShortcutItem item}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: item.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          spacing: 4,
          children: [
            Icon(item.icon, size: 28, color: SemanticColor.light.labelPrimary),
            Text(item.label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

final class _ShortcutItem {
  const _ShortcutItem({required IconData icon, required String label, required VoidCallback onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
}
