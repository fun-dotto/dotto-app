import 'dart:async';

import 'package:dotto/domain/domain_error.dart';
import 'package:dotto/feature/announcement/announcement_action.dart';
import 'package:dotto/repository/announcement_repository.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void useAnnouncementEffects({
  required int fetchEpoch,
  required void Function(AnnouncementAction) dispatch,
  required WidgetRef ref,
  required ObjectRef<Completer<void>?> pendingRefresh,
}) {
  useEffect(() {
    var cancelled = false;
    unawaited(() async {
      try {
        final announcements = await ref
            .read(announcementRepositoryProvider)
            .getAnnouncements();
        if (cancelled) return;
        dispatch(AnnouncementAction.announcementsLoaded(announcements));
      } on DomainError catch (e) {
        if (cancelled) return;
        dispatch(AnnouncementAction.announcementsFailed(e));
      } finally {
        if (!cancelled) {
          final completer = pendingRefresh.value;
          if (completer != null && !completer.isCompleted) {
            completer.complete();
          }
          pendingRefresh.value = null;
        }
      }
    }());
    return () => cancelled = true;
  }, [fetchEpoch]);
}
