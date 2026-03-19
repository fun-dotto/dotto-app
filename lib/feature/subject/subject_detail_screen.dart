import 'package:dotto/api/api_client.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/subject/subject_detail_past_exam_screen.dart';
import 'package:dotto/feature/subject/subject_detail_syllabus_screen.dart';
import 'package:dotto/feature/subject/subject_repository.dart';
import 'package:dotto/feature/subject_detail_v0/kamoku_detail_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class SubjectDetailScreen extends HookConsumerWidget {
  const SubjectDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final subjectRepository = SubjectRepositoryImpl(apiClient);
    final subjectSnapshot = useFuture(useMemoized(() => subjectRepository.getSubject(id)));
    final isAuthenticated = ref.watch(userProvider.notifier).isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: Text(subjectSnapshot.data?.name ?? ''),
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
              return const CircularProgressIndicator();
            }
            if (subjectSnapshot.hasError) {
              debugPrint(subjectSnapshot.error.toString());
              return const Text('シラバスの読み込みに失敗しました。');
            }
            if (subjectSnapshot.hasData) {
              final subject = subjectSnapshot.data!;
              return SubjectDetailSyllabusScreen(syllabus: subject.syllabus);
            }
            return const SizedBox.shrink();
          }(),
          () {
            if (subjectSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (subjectSnapshot.hasError) {
              debugPrint(subjectSnapshot.error.toString());
              return const Text('シラバスの読み込みに失敗しました。');
            }
            if (subjectSnapshot.hasData) {
              final subject = subjectSnapshot.data!;
              return KamokuFeedbackScreen(lessonId: int.parse(subject.syllabus.id), isAuthenticated: isAuthenticated);
            }
            return const SizedBox.shrink();
          }(),
          () {
            if (subjectSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (subjectSnapshot.hasError) {
              debugPrint(subjectSnapshot.error.toString());
              return const Text('シラバスの読み込みに失敗しました。');
            }
            if (subjectSnapshot.hasData) {
              final subject = subjectSnapshot.data!;
              return SubjectDetailPastExamScreen(pastExamId: subject.pastExamId, isAuthenticated: isAuthenticated);
            }
            return const SizedBox.shrink();
          }(),
        ],
      ),
    );
  }
}
