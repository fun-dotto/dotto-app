import 'dart:async';

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/course/course_cancellation_screen.dart';
import 'package:dotto/feature/course/course_customize_screen.dart';
import 'package:dotto/feature/course/course_reducer.dart';
import 'package:dotto/feature/course/course_registration_screen.dart';
import 'package:dotto/feature/course/course_state.dart';
import 'package:dotto/feature/course/personal_timetable_calendar_view.dart';
import 'package:dotto/feature/course/quick_button.dart';
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
    final state = isAuthenticated ? ref.watch(courseReducerProvider) : const AsyncData(CourseState());
    final selectedDate = useState<DateTime?>(null);

    final quickFeatures = [
      if (config.isFunchEnabled)
        QuickButton(
          label: '科目検索',
          iconUrl: null,
          fallbackIcon: Icons.search,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => const SearchSubjectScreen(),
              settings: const RouteSettings(name: '/course/subjects'),
            ),
          ),
        ),
      if (isAuthenticated)
        QuickButton(
          label: '休講・補講',
          iconUrl: null,
          fallbackIcon: Icons.cached,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => const CourseCancellationScreen(),
              settings: const RouteSettings(name: '/course/cancellations'),
            ),
          ),
        ),
    ];

    final quickFiles = [
      QuickButton(
        label: '学年歴',
        iconUrl: null,
        fallbackIcon: Icons.event_note,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => WebPdfViewer(url: config.officialCalendarPdfUrl, filename: '学年暦'),
            settings: RouteSettings(name: '/home/web_pdf_viewer?url=${config.officialCalendarPdfUrl}'),
          ),
        ),
      ),
      QuickButton(
        label: '時間割 前期',
        iconUrl: null,
        fallbackIcon: Icons.calendar_view_month,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => WebPdfViewer(url: config.timetable1PdfUrl, filename: '時間割 前期'),
            settings: RouteSettings(name: '/home/web_pdf_viewer?url=${config.timetable1PdfUrl}'),
          ),
        ),
      ),
      QuickButton(
        label: '時間割 後期',
        iconUrl: null,
        fallbackIcon: Icons.calendar_view_month,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => WebPdfViewer(url: config.timetable2PdfUrl, filename: '時間割 後期'),
            settings: RouteSettings(name: '/home/web_pdf_viewer?url=${config.timetable2PdfUrl}'),
          ),
        ),
      ),
    ];

    final quickLinks = [
      QuickButton(
        label: 'HOPE',
        iconUrl: 'https://hope.fun.ac.jp/pluginfile.php/1/core_admin/favicon/64x64/1756948564/favicon.ico',
        fallbackIcon: Icons.language,
        onPressed: () => _launchQuickLink(
          context,
          url: 'https://hope.fun.ac.jp/auth/saml2/login.php?idp=1bec319bca7458548c77d545a2a1b3de',
          label: 'HOPE',
        ),
      ),
      QuickButton(
        label: '学生ポータル',
        iconUrl: 'https://students.fun.ac.jp/favicon.ico',
        fallbackIcon: Icons.language,
        onPressed: () => _launchQuickLink(context, url: 'https://students.fun.ac.jp/Portal', label: '学生ポータル'),
      ),
      // if (isAuthenticated)
      //   QuickButton(
      //     label: 'Dotto Web',
      //     iconUrl: '${config.dottoWebUrl}/favicon.ico',
      //     fallbackIcon: Icons.language,
      //     onPressed: () => _launchQuickLink(context, url: config.dottoWebUrl, label: 'Dotto Web'),
      //   ),
      if (isAuthenticated)
        QuickButton(
          label: 'Macサポート',
          iconUrl: null,
          fallbackIcon: Icons.laptop_mac,
          onPressed: () => _launchQuickLink(context, url: config.macSupportDeskUrl, label: 'Macサポート'),
        ),
    ];

    // courseReducerProvider.build() already fetches data when first watched.
    // No need to call refresh() here as it would duplicate the initial API call.

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
        title: Text(
          '講義',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: SemanticColor.light.accentPrimary),
        ),
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
        bottom: () {
          final announcement = config.breakingAnnouncement;
          if (announcement == null) {
            return null;
          }
          return PreferredSize(
            preferredSize: const Size.fromHeight(32),
            child: Material(
              color: SemanticColor.light.accentPrimary.withValues(alpha: 0.75),
              child: InkWell(
                onTap: () => _launchQuickLink(context, url: announcement.url, label: announcement.title),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    announcement.title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: SemanticColor.light.labelTertiary),
                    textAlign: .center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }(),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    spacing: 16,
                    children: [
                      if (isAuthenticated)
                        Column(
                          children: [
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
                            ),
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
                          ],
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
                      Padding(
                        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
                        child: _shortcutSections(
                          context,
                          isAuthenticated: isAuthenticated,
                          quickFeatures: quickFeatures,
                          quickFiles: quickFiles,
                          quickLinks: quickLinks,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        AsyncLoading() => _loadingSkeleton(
          context,
          isAuthenticated: isAuthenticated,
          quickFeatures: quickFeatures,
          quickFiles: quickFiles,
          quickLinks: quickLinks,
        ),
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

  Widget _loadingSkeleton(
    BuildContext context, {
    required bool isAuthenticated,
    required List<QuickButton> quickFeatures,
    required List<QuickButton> quickFiles,
    required List<QuickButton> quickLinks,
  }) {
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
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
                    child: Center(child: DottoButton(onPressed: null, child: const Text('ログインして時間割機能を使う'))),
                  ),
                if (isAuthenticated)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [DottoButton(onPressed: null, type: DottoButtonType.text, child: const Text('1週間の時間割'))],
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _shortcutSections(
                    context,
                    isAuthenticated: isAuthenticated,
                    quickFeatures: quickFeatures,
                    quickFiles: quickFiles,
                    quickLinks: quickLinks,
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
    required List<QuickButton> quickFeatures,
    required List<QuickButton> quickFiles,
    required List<QuickButton> quickLinks,
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
          spacing: 12,
          children: [
            _shortcutSection(context, quickButtons: quickFeatures),
            const Divider(height: 0),
            _shortcutSection(context, quickButtons: quickFiles),
            const Divider(height: 0),
            _shortcutSection(context, quickButtons: quickLinks),
          ],
        ),
      ),
    );
  }

  Widget _shortcutSection(BuildContext context, {required List<QuickButton> quickButtons}) {
    if (quickButtons.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quickButtons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 64,
      ),
      itemBuilder: (context, index) => quickButtons[index],
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _launchQuickLink(BuildContext context, {required String url, required String label}) async {
    final launched = await launchUrlString(url, mode: LaunchMode.externalApplication);
    if (!context.mounted || launched) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label を開けませんでした')));
  }
}
