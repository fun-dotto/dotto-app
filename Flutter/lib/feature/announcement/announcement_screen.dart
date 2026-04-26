import 'package:dotto/domain/announcement.dart';
import 'package:dotto/feature/announcement/announcement_store.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:dotto/helper/url_launcher_helper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class AnnouncementScreen extends HookConsumerWidget {
  const AnnouncementScreen({super.key});

  Widget _announcementListRow(BuildContext context, Announcement announcement) {
    return ListTile(
      title: Text(
        announcement.title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        DateFormatter.full(announcement.date),
        style: Theme.of(context).textTheme.labelMedium,
      ),
      onTap: () => launchUrlSafely(announcement.url),
      trailing: const Icon(Icons.chevron_right_outlined),
    );
  }

  Widget _body(
    BuildContext context,
    AsyncValue<List<Announcement>> announcements, {
    required Future<void> Function() onRefresh,
  }) {
    switch (announcements) {
      case AsyncData(:final value):
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            itemCount: value.length,
            separatorBuilder: (_, _) => const Divider(height: 0),
            itemBuilder: (_, index) =>
                _announcementListRow(context, value[index]),
          ),
        );
      case AsyncError(:final error):
        return Center(child: Text('エラーが発生しました: $error'));
      case AsyncLoading():
        return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = useAnnouncementStore(ref);

    return Scaffold(
      appBar: AppBar(title: const Text('お知らせ')),
      body: _body(
        context,
        store.state.announcements,
        onRefresh: store.refresh,
      ),
    );
  }
}
