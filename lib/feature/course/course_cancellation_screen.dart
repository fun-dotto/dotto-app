import 'dart:async';

import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/course/course_cancellation_reducer.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openapi/openapi.dart';

final class CourseCancellationScreen extends ConsumerWidget {
  const CourseCancellationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('休講・補講・教室変更')),
        body: const Center(child: Text('Googleアカウント(@fun.ac.jp)ログインが必要です。')),
      );
    }

    final state = ref.watch(courseCancellationReducerProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('休講・補講・教室変更'),
          actions: [
            DottoButton(
              onPressed: () => unawaited(ref.read(courseCancellationReducerProvider.notifier).toggleFilter()),
              type: DottoButtonType.text,
              child: Row(
                spacing: 4,
                children: [
                  Icon(state.value?.isFiltered ?? false ? Icons.filter_alt : Icons.filter_alt_outlined),
                  Text((state.value?.isFiltered ?? false) ? '履修中' : 'すべて'),
                ],
              ),
            ),
          ],
          bottom: const TabBar(
            dividerHeight: 0,
            tabs: [
              Tab(text: '休講'),
              Tab(text: '補講'),
              Tab(text: '教室変更'),
            ],
          ),
        ),
        body: switch (state) {
          AsyncData(value: final value) => TabBarView(
            children: [
              _CancelledClassList(
                items: value.cancelledClasses,
                onRefresh: () => ref.read(courseCancellationReducerProvider.notifier).refresh(),
              ),
              _MakeupClassList(
                items: value.makeupClasses,
                onRefresh: () => ref.read(courseCancellationReducerProvider.notifier).refresh(),
              ),
              _RoomChangeList(
                items: value.roomChanges,
                onRefresh: () => ref.read(courseCancellationReducerProvider.notifier).refresh(),
              ),
            ],
          ),
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
          AsyncError() => const Center(child: Text('データの取得に失敗しました。')),
        },
      ),
    );
  }
}

class _CancelledClassList extends StatelessWidget {
  const _CancelledClassList({required this.items, required this.onRefresh});

  final List<CancelledClass> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Center(child: Text('休講はありません。')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final item = items[index];
          final subtitleLines = <String>[item.subject.name];
          if (item.comment.trim().isNotEmpty) {
            subtitleLines.add(item.comment.trim());
          }
          return ListTile(
            title: Text(
              '${_formatDate(item.date)} ${_formatPeriod(item.period)}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            subtitle: Text(subtitleLines.join('\n')),
          );
        },
      ),
    );
  }
}

class _MakeupClassList extends StatelessWidget {
  const _MakeupClassList({required this.items, required this.onRefresh});

  final List<MakeupClass> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Center(child: Text('補講はありません。')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final item = items[index];
          final subtitleLines = <String>[item.subject.name];
          if (item.comment.trim().isNotEmpty) {
            subtitleLines.add(item.comment.trim());
          }
          return ListTile(
            title: Text(
              '${_formatDate(item.date)} ${_formatPeriod(item.period)}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            subtitle: Text(subtitleLines.join('\n')),
          );
        },
      ),
    );
  }
}

class _RoomChangeList extends StatelessWidget {
  const _RoomChangeList({required this.items, required this.onRefresh});

  final List<RoomChange> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Center(child: Text('教室変更はありません。')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(
              '${_formatDate(item.date)} ${_formatPeriod(item.period)}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            subtitle: Text('${item.subject.name}\n${item.originalRoom.name} → ${item.newRoom.name}'),
          );
        },
      ),
    );
  }
}

String _formatDate(Date value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}/$month/$day';
}

String _formatPeriod(DottoFoundationV1Period period) {
  return switch (period) {
    DottoFoundationV1Period.period1 => '1限',
    DottoFoundationV1Period.period2 => '2限',
    DottoFoundationV1Period.period3 => '3限',
    DottoFoundationV1Period.period4 => '4限',
    DottoFoundationV1Period.period5 => '5限',
    DottoFoundationV1Period.period6 => '6限',
    _ => period.name,
  };
}
