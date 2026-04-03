import 'package:freezed_annotation/freezed_annotation.dart';

part 'breaking_announcement.freezed.dart';
part 'breaking_announcement.g.dart';

@freezed
abstract class BreakingAnnouncement with _$BreakingAnnouncement {
  //
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BreakingAnnouncement({String? title, String? url, bool? isExternal}) = _BreakingAnnouncement;

  factory BreakingAnnouncement.fromJson(Map<String, Object?> json) => _$BreakingAnnouncementFromJson(json);
}
