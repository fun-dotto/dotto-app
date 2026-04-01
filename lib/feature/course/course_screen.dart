import 'dart:async';

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/domain/config.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/quick_link.dart';
import 'package:dotto/feature/course/course_cancellation_screen.dart';
import 'package:dotto/feature/course/course_customize_screen.dart';
import 'package:dotto/feature/course/course_reducer.dart';
import 'package:dotto/feature/course/course_registration_screen.dart';
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
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class CourseScreen extends HookConsumerWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
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
      appBar: AppBar(
        title: const Text('講義'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                fullscreenDialog: true,
                builder: (context) => const CourseCustomizeScreen(),
                settings: const RouteSettings(name: '/course/customize'),
              ),
            ),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
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
                          child: DottoButton(
                            onPressed: () async {
                              await ref.read(userProvider.notifier).signIn();
                            },
                            child: const Text('ログインして時間割機能を使う'),
                          ),
                        ),
                      ),
                    if (isAuthenticated)
                      Row(
                        mainAxisAlignment: .end,
                        children: [
                          DottoButton(
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => const CourseRegistrationScreen(),
                                  settings: const RouteSettings(name: '/course/registration'),
                                ),
                              );
                              if (!context.mounted) {
                                return;
                              }
                              await ref.read(courseReducerProvider.notifier).refresh();
                            },
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
                          ('時間割 前期', config.timetable1PdfUrl, Icons.calendar_view_month),
                          ('時間割 後期', config.timetable2PdfUrl, Icons.calendar_view_month),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AsyncLoading() => _loadingSkeleton(context, isAuthenticated: isAuthenticated, config: config),
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

  Widget _loadingSkeleton(BuildContext context, {required bool isAuthenticated, required AsyncValue<Config> config}) {
    final configValue = config.valueOrNull;
    return LayoutBuilder(
      builder: (context, constraints) => RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                if (isAuthenticated)
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: _courseTimetableSkeleton(context))
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
                    child: Center(child: DottoButton(onPressed: null, child: const Text('ログインして時間割機能を使う'))),
                  ),
                if (isAuthenticated)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [DottoButton(onPressed: null, type: DottoButtonType.text, child: const Text('1週間の時間割'))],
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _shortcutSections(
                    context,
                    isAuthenticated: isAuthenticated,
                    quickLinksByLabel: {for (final link in QuickLink.links) link.label: link},
                    fileItems: [
                      ('学年暦', configValue?.officialCalendarPdfUrl ?? '', Icons.event_note),
                      ('時間割 前期', configValue?.timetable1PdfUrl ?? '', Icons.calendar_view_month),
                      ('時間割 後期', configValue?.timetable2PdfUrl ?? '', Icons.calendar_view_month),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _courseTimetableSkeleton(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [_skeletonBox(height: 14, width: 28), const SizedBox(height: 8), _skeletonCircle(48)],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          6,
          (index) => Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 8, right: 8),
            child: Row(
              children: [
                SizedBox(width: 28, child: Center(child: Text('${index + 1}'))),
                const SizedBox(width: 8),
                Expanded(child: _courseTimetableCellSkeleton()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _skeletonCircle(double size) {
    return Shimmer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
      ),
    );
  }

  Widget _courseTimetableCellSkeleton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: const BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _skeletonBox(height: 12, width: 96, radius: 4),
          const SizedBox(height: 8),
          _skeletonBox(height: 10, width: 48, radius: 4),
        ],
      ),
    );
  }

  Widget _skeletonBox({required double height, double? width, double radius = 8}) {
    return Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(radius)),
      ),
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
          spacing: 8,
          children: [
            _shortcutSection(
              context,
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
                    icon: Icons.cached,
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
            const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(height: 1)),
            _shortcutSection(
              context,
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
            const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(height: 1)),
            _shortcutSection(
              context,
              items: [
                if (quickLinksByLabel['HOPE'] case final hope?)
                  _ShortcutItem(
                    imageUrl: hope.icon,
                    label: hope.label,
                    onPressed: () => _launchQuickLink(context, hope),
                  ),
                if (quickLinksByLabel['学生ポータル'] case final portal?)
                  _ShortcutItem(
                    imageUrl: portal.icon,
                    label: portal.label,
                    onPressed: () => _launchQuickLink(context, portal),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shortcutSection(BuildContext context, {required List<_ShortcutItem> items}) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 64,
      ),
      itemBuilder: (context, index) => _shortcutButton(context, item: items[index]),
    );
  }

  Widget _shortcutButton(BuildContext context, {required _ShortcutItem item}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: item.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            if (item.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  item.imageUrl!,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(item.icon, size: 24, color: SemanticColor.light.labelPrimary),
                ),
              )
            else
              Icon(item.icon, size: 24, color: SemanticColor.light.labelPrimary),
            Text(item.label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _launchQuickLink(BuildContext context, QuickLink link) async {
    final launched = await launchUrlString(link.url, mode: LaunchMode.externalApplication);
    if (!context.mounted || launched) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${link.label} を開けませんでした')));
  }
}

final class _ShortcutItem {
  const _ShortcutItem({required this.label, required this.onPressed, this.icon = Icons.link, this.imageUrl});

  final IconData icon;
  final String? imageUrl;
  final String label;
  final VoidCallback onPressed;
}
