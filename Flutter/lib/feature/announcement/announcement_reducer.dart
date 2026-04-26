import 'package:dotto/feature/announcement/announcement_action.dart';
import 'package:dotto/feature/announcement/announcement_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

AnnouncementState announcementReduce(
  AnnouncementState state,
  AnnouncementAction action,
) {
  return switch (action) {
    RefreshRequested() => state.copyWith(
      announcements: const AsyncValue.loading(),
      fetchEpoch: state.fetchEpoch + 1,
    ),
    AnnouncementsLoaded(:final announcements) => state.copyWith(
      announcements: AsyncValue.data(announcements),
    ),
    AnnouncementsFailed(:final error) => state.copyWith(
      announcements: AsyncValue.error(error, StackTrace.current),
    ),
  };
}
