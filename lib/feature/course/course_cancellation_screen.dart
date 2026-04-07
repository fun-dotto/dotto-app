import 'dart:async';

import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/course/course_cancellation_reducer.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
              onPressed: () => unawaited(
                ref
                    .read(courseCancellationReducerProvider.notifier)
                    .toggleFilter(),
              ),
              type: DottoButtonType.text,
              child: Row(
                spacing: 4,
                children: [
                  Icon(
                    state.value?.isFiltered ?? false
                        ? Icons.filter_alt
                        : Icons.filter_alt_outlined,
                  ),
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
                onRefresh: () => ref
                    .read(courseCancellationReducerProvider.notifier)
                    .refresh(),
              ),
              _MakeupClassList(
                items: value.makeupClasses,
                onRefresh: () => ref
                    .read(courseCancellationReducerProvider.notifier)
                    .refresh(),
              ),
              _RoomChangeList(
                items: value.roomChanges,
                onRefresh: () => ref
                    .read(courseCancellationReducerProvider.notifier)
                    .refresh(),
              ),
            ],
          ),
          AsyncLoading() => const _LoadingSkeleton(),
          AsyncError() => const Center(child: Text('データの取得に失敗しました。')),
        },
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      separatorBuilder: (_, _) => const Divider(height: 0),
      itemBuilder: (_, _) => const _ListTileSkeleton(),
    );
  }
}

class _ListTileSkeleton extends StatelessWidget {
  const _ListTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonBox(height: 12, width: 120),
          const SizedBox(height: 8),
          _skeletonBox(height: 14, width: 200),
        ],
      ),
    );
  }
}

Widget _skeletonBox({required double height, required double width}) {
  return Shimmer(
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
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
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatDate(item.date)} ${_formatPeriod(item.period)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  item.subject.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            subtitle: item.comment.trim().isNotEmpty
                ? Text(
                    item.comment.trim(),
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                : null,
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
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatDate(item.date)} ${_formatPeriod(item.period)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  item.subject.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            subtitle: item.comment.trim().isNotEmpty
                ? Text(
                    item.comment.trim(),
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                : null,
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatDate(item.date)} ${_formatPeriod(item.period)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  item.subject.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            subtitle: Text(
              '${item.originalRoom.name} → ${item.newRoom.name}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          );
        },
      ),
    );
  }
}

String _formatDate(Date value) {
  final dateTime = value.toDateTime();
  return DateFormatter.dateWithDayOfWeek(dateTime);
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
