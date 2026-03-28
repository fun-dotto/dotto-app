import 'dart:async';

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/quick_link.dart';
import 'package:dotto/feature/course/course_cancellation_screen.dart';
import 'package:dotto/feature/course/course_registration_screen.dart';
import 'package:dotto/feature/course/course_reducer.dart';
import 'package:dotto/feature/course/personal_timetable_calendar_view.dart';
import 'package:dotto/feature/home/component/file_grid.dart';
import 'package:dotto/feature/home/component/file_tile.dart';
import 'package:dotto/feature/home/component/link_grid.dart';
import 'package:dotto/feature/subject/search_subject_screen.dart';
import 'package:dotto/feature/subject/subject_detail_screen.dart';
import 'package:dotto/widget/web_pdf_viewer.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class CourseScreen extends HookConsumerWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final isAuthenticated = ref.watch(userProvider.notifier).isAuthenticated;
    // final timetablePeriodStyle = ref.watch(timetablePeriodStyleProvider);
    final fileItems = <(String label, String url, IconData icon)>[
      ('学年暦', config.officialCalendarPdfUrl, Icons.event_note),
      ('時間割 前期', config.timetable1PdfUrl, Icons.calendar_month),
      ('時間割 後期', config.timetable2PdfUrl, Icons.calendar_month),
    ];
    final infoTiles = <Widget>[
      ...fileItems.map(
        (item) => FileTile(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => WebPdfViewer(url: item.$2, filename: item.$1),
                settings: RouteSettings(name: '/home/web_pdf_viewer?url=${item.$2}'),
              ),
            );
          },
          icon: item.$3,
          title: item.$1,
        ),
      ),
    ];
    final state = ref.watch(courseReducerProvider);
    final selectedDate = useState<DateTime?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(ref.read(courseReducerProvider.notifier).refresh());
      });
      return null;
    }, []);

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
        AsyncData(value: final courseState) => RefreshIndicator(
          onRefresh: () => ref.read(courseReducerProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _featureButtons(context, isAuthenticated: isAuthenticated),
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.all(16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      spacing: 16,
                      children: [
                        // const BusCardHome(),
                        Column(
                          spacing: 8,
                          children: [
                            FileGrid(children: infoTiles),
                            const LinkGrid(links: QuickLink.links),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError() => RefreshIndicator(
          onRefresh: () => ref.read(courseReducerProvider.notifier).refresh(),
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

  Widget _featureButtons(BuildContext context, {required bool isAuthenticated}) {
    final buttons = <Widget>[
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
      if (isAuthenticated)
        _featureButton(
          context,
          icon: Icons.calendar_month,
          label: '休講・補講',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => const CourseCancellationScreen(),
              settings: const RouteSettings(name: '/course/cancellations'),
            ),
          ),
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: SemanticColor.light.borderPrimary),
        borderRadius: BorderRadius.circular(16),
        color: SemanticColor.light.backgroundSecondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(mainAxisAlignment: .center, spacing: 8, children: buttons),
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
