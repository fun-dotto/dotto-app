import 'dart:async';

import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/course_cancellation.dart';
import 'package:dotto/feature/course/course_cancellation_reducer.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class CourseCancellationScreen extends HookConsumerWidget {
  const CourseCancellationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(userProvider.notifier).isAuthenticated;
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('休講・補講')),
        body: const Center(child: Text('Googleアカウント(@fun.ac.jp)ログインが必要です。')),
      );
    }

    final state = ref.watch(courseCancellationReducerProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(ref.read(courseCancellationReducerProvider.notifier).refresh());
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('休講・補講'),
        actions: [
          DottoButton(
            onPressed: () => unawaited(ref.read(courseCancellationReducerProvider.notifier).toggleFilter()),
            type: DottoButtonType.text,
            child: Row(
              spacing: 4,
              children: [
                Icon(
                  state.value?.isFilteredOnlyTakingCourseCancellation ?? false
                      ? Icons.filter_alt
                      : Icons.filter_alt_outlined,
                ),
                Text((state.value?.isFilteredOnlyTakingCourseCancellation ?? false) ? '履修中' : 'すべて'),
              ],
            ),
          ),
        ],
      ),
      body: switch (state) {
        AsyncData(value: final value) => RefreshIndicator(
          onRefresh: () => ref.read(courseCancellationReducerProvider.notifier).refresh(),
          child: _buildCancellationList(context, value.cancellations),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError() => const Center(child: Text('データの取得に失敗しました。')),
      },
    );
  }

  Widget _buildCancellationList(BuildContext context, List<CourseCancellation> cancellations) {
    if (cancellations.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 160),
          Center(child: Text('休講・補講はありません。')),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: cancellations.length,
      separatorBuilder: (_, _) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final item = cancellations[index];
        final subtitleLines = <String>[item.lessonName];
        if (item.comment.trim().isNotEmpty) {
          subtitleLines.add(item.comment.trim());
        }
        return ListTile(
          title: Text(
            '${_formatDate(item.date)} ${item.period.number}限 (${item.type.label})',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          subtitle: Text(subtitleLines.join('\n')),
        );
      },
    );
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}/$month/$day';
  }
}
