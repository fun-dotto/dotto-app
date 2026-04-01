import 'package:dotto/api/api_client.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/subject/subject_detail_feedback_screen.dart';
import 'package:dotto/feature/subject/subject_detail_past_exam_screen.dart';
import 'package:dotto/feature/subject/subject_detail_syllabus_screen.dart';
import 'package:dotto/repository/subject_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

final class SubjectDetailScreen extends HookConsumerWidget {
  const SubjectDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final subjectRepository = SubjectRepositoryImpl(apiClient);
    final subjectSnapshot = useFuture(useMemoized(() => subjectRepository.getSubject(id)));
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: subjectSnapshot.connectionState == ConnectionState.waiting
              ? Align(alignment: Alignment.centerLeft, child: _skeletonBox(height: 20, width: 144, radius: 6))
              : Text(subjectSnapshot.data?.name ?? ''),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(text: 'シラバス'),
              Tab(text: 'レビュー'),
              Tab(text: '過去問'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            () {
              if (subjectSnapshot.connectionState == ConnectionState.waiting) {
                return const _SubjectDetailSyllabusSkeleton();
              }
              if (subjectSnapshot.hasError) {
                debugPrint(subjectSnapshot.error.toString());
                return const Center(child: Text('科目情報の読み込みに失敗しました。'));
              }
              if (subjectSnapshot.hasData) {
                final subject = subjectSnapshot.data!;
                return SubjectDetailSyllabusScreen(syllabus: subject.syllabus);
              }
              return const SizedBox.shrink();
            }(),
            () {
              if (subjectSnapshot.connectionState == ConnectionState.waiting) {
                return const _SubjectDetailFeedbackSkeleton();
              }
              if (subjectSnapshot.hasError) {
                debugPrint(subjectSnapshot.error.toString());
                return const Center(child: Text('科目情報の読み込みに失敗しました。'));
              }
              if (subjectSnapshot.hasData) {
                final subject = subjectSnapshot.data!;
                return SubjectDetailFeedbackScreen(lessonId: subject.syllabus.id);
              }
              return const SizedBox.shrink();
            }(),
            () {
              if (subjectSnapshot.connectionState == ConnectionState.waiting) {
                return const _SubjectDetailPastExamSkeleton();
              }
              if (subjectSnapshot.hasError) {
                debugPrint(subjectSnapshot.error.toString());
                return const Center(child: Text('科目情報の読み込みに失敗しました。'));
              }
              if (subjectSnapshot.hasData) {
                final subject = subjectSnapshot.data!;
                return SubjectDetailPastExamScreen(pastExamId: subject.pastExamId, isAuthenticated: isAuthenticated);
              }
              return const SizedBox.shrink();
            }(),
          ],
        ),
      ),
    );
  }
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

final class _SubjectDetailSyllabusSkeleton extends StatelessWidget {
  const _SubjectDetailSyllabusSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < 6; index++) ...[
            _skeletonBox(height: 18, width: 96 + (index.isEven ? 24 : 48), radius: 4),
            const SizedBox(height: 12),
            _skeletonBox(height: 14, width: double.infinity, radius: 4),
            const SizedBox(height: 8),
            _skeletonBox(height: 14, width: index.isEven ? 240 : 280, radius: 4),
            if (index < 5) ...[const SizedBox(height: 16), const Divider(height: 0), const SizedBox(height: 16)],
          ],
        ],
      ),
    );
  }
}

final class _SubjectDetailFeedbackSkeleton extends StatelessWidget {
  const _SubjectDetailFeedbackSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonBox(height: 36, width: 64, radius: 6),
                    const SizedBox(height: 8),
                    _skeletonBox(height: 12, width: 84, radius: 4),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: index == 4 ? 0 : 8),
                        child: Row(
                          children: [
                            _skeletonBox(height: 12, width: 56, radius: 4),
                            const SizedBox(width: 8),
                            Expanded(child: _skeletonBox(height: 8, radius: 999)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: ListView.separated(
              itemCount: 4,
              separatorBuilder: (_, _) => const Divider(height: 0),
              itemBuilder: (_, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _skeletonBox(height: 12, width: 72, radius: 4),
                      const SizedBox(height: 8),
                      _skeletonBox(height: 14, width: double.infinity, radius: 4),
                      const SizedBox(height: 6),
                      _skeletonBox(height: 14, width: 220, radius: 4),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final class _SubjectDetailPastExamSkeleton extends StatelessWidget {
  const _SubjectDetailPastExamSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, _) => const Divider(height: 0),
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              Expanded(child: _skeletonBox(height: 16, width: index.isEven ? 240 : 200, radius: 4)),
              const SizedBox(width: 12),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        );
      },
    );
  }
}
