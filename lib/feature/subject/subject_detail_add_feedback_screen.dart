import 'package:dotto/api/api_client.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/subject_feedback.dart';
import 'package:dotto/repository/subject_repository.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class SubjectDetailAddFeedbackScreen extends HookConsumerWidget {
  const SubjectDetailAddFeedbackScreen({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final apiClient = ref.read(apiClientProvider);
    final subjectRepository = SubjectRepositoryImpl(apiClient);
    final score = useState<int?>(null);
    final commentTextEditingController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('フィードバックを投稿'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: switch (user) {
              AsyncData(:final value) => () async {
                try {
                  if (score.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('満足度を入力してください。')),
                    );
                    return;
                  }
                  final feedback = SubjectFeedback(
                    score: score.value!,
                    comment: commentTextEditingController.text,
                  );
                  await subjectRepository.createFeedback(
                    userId: value.id,
                    lessonId: lessonId,
                    score: feedback.score,
                    comment: feedback.comment,
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop(feedback);
                  }
                } on Exception catch (e) {
                  debugPrint(e.toString());
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('フィードバックの投稿に失敗しました。')),
                    );
                  }
                }
              },
              _ => null,
            },
            child: const Text('投稿する'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'タップして評価:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: SemanticColor.light.accentPrimary,
                    ),
                  ),
                ),
                RatingBar.builder(
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: SemanticColor.light.accentPrimary,
                  ),
                  onRatingUpdate: (rating) => score.value = rating.toInt(),
                  glow: false,
                  itemSize: 32,
                  minRating: 1,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'コメント',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: SemanticColor.light.accentPrimary,
                  ),
                ),
                TextFormField(
                  maxLength: 30,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    border: OutlineInputBorder(),
                    hintText: '単位、出席、テストの情報など...',
                  ),
                  controller: commentTextEditingController,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
