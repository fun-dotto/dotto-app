import 'package:dotto/domain/announcement.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_action.freezed.dart';

@freezed
sealed class AnnouncementAction with _$AnnouncementAction {
  const factory AnnouncementAction.refreshRequested() = RefreshRequested;
  const factory AnnouncementAction.announcementsLoaded(
    List<Announcement> announcements,
  ) = AnnouncementsLoaded;
  const factory AnnouncementAction.announcementsFailed(DomainError error) =
      AnnouncementsFailed;
}
