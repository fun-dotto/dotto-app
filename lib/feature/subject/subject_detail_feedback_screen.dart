import 'package:collection/collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/subject_feedback.dart';
import 'package:dotto/feature/subject/subject_detail_add_feedback_screen.dart';
import 'package:dotto/feature/subject/subject_repository.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class SubjectDetailFeedbackScreen extends HookConsumerWidget {
  const SubjectDetailFeedbackScreen({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isAuthenticated = ref.watch(userProvider.notifier).isAuthenticated;
    final apiClient = ref.read(apiClientProvider);
    final subjectRepository = SubjectRepositoryImpl(apiClient);
    final feedbacksSnapshot = useFuture(useMemoized(() => subjectRepository.getFeedbacks(lessonId)));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: () {
          if (feedbacksSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (feedbacksSnapshot.hasError) {
            debugPrint(feedbacksSnapshot.error.toString());
            return const Text('フィードバックの読み込みに失敗しました。');
          }
          if (feedbacksSnapshot.hasData) {
            final feedbacks = feedbacksSnapshot.data!;
            if (feedbacks.isEmpty) {
              return const Center(child: Text('フィードバックがありません'));
            }
            return Column(
              children: [_feedbackSummary(context, feedbacks), const Divider(height: 0), _feedbackList(feedbacks)],
            );
          }
          return const SizedBox.shrink();
        }(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!isAuthenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Googleアカウント (@fun.ac.jp) による認証が必要です。')));
            return;
          }
          final result = await showModalBottomSheet<SubjectFeedback>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => SubjectDetailAddFeedbackScreen(lessonId: lessonId, userId: user?.uid ?? ''),
          );
          if (result != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('フィードバックを投稿しました。')));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _feedbackSummary(BuildContext context, List<SubjectFeedback> feedbacks) {
    final averageScore = feedbacks.map((feedback) => feedback.score).reduce((a, b) => a + b) / feedbacks.length;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(averageScore.toStringAsFixed(1), style: Theme.of(context).textTheme.displayLarge),
              const Text('5段階評価中'),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final rating in [5, 4, 3, 2, 1])
                  _buildRatingBar(rating, feedbacks.where((f) => f.score == rating).length / feedbacks.length),
                Text('${feedbacks.length}件のフィードバック'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackList(List<SubjectFeedback> feedbacks) {
    final filteredFeedbacks = feedbacks
        .where((feedback) => feedback.comment.isNotEmpty)
        .toList()
        .sorted((a, b) => b.score.compareTo(a.score));
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (_, _) => const Divider(height: 0),
        itemCount: filteredFeedbacks.length,
        itemBuilder: (context, index) {
          final feedback = filteredFeedbacks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                _stars(rating: feedback.score),
                Text(feedback.comment),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingBar(int rating, double ratio) {
    return Row(
      spacing: 4,
      children: [
        _stars(rating: rating, inverse: true),
        Expanded(
          child: LinearProgressIndicator(
            value: ratio,
            color: SemanticColor.light.accentPrimary,
            backgroundColor: SemanticColor.light.backgroundTertiary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _stars({required int rating, bool inverse = false}) {
    return Row(
      children: List.generate(5, (index) {
        if (inverse) {
          return index >= 5 - rating ? const Icon(Icons.star, size: 12) : const SizedBox(width: 12);
        }
        return index < rating ? const Icon(Icons.star, size: 12) : const SizedBox(width: 12);
      }),
    );
  }
}
