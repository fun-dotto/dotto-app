import 'package:dotto/domain/announcement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_state.freezed.dart';

@freezed
abstract class AnnouncementState with _$AnnouncementState {
  const factory AnnouncementState({
    required AsyncValue<List<Announcement>> announcements,
    required int fetchEpoch,
  }) = _AnnouncementState;

  factory AnnouncementState.initial() => const AnnouncementState(
    announcements: AsyncValue.loading(),
    fetchEpoch: 0,
  );
}
