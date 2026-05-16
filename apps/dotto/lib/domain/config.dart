import 'package:dotto/domain/breaking_announcement.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';

@freezed
abstract class Config with _$Config {
  const factory Config({
    required bool isFunchEnabled,
    required String validAppVersion,
    required String latestAppVersion,
    required bool isUnderMaintenance,
    required String feedbackFormUrl,
    required String termsOfServiceUrl,
    required String privacyPolicyUrl,
    required String appStorePageUrl,
    required String officialCalendarPdfUrl,
    required String timetable1PdfUrl,
    required String timetable2PdfUrl,
    required BreakingAnnouncement? breakingAnnouncement,
    required String dottoWebUrl,
    required String macSupportDeskUrl,
  }) = _Config;

  static const String cloudflareR2Endpoint = String.fromEnvironment(
    'CLOUDFLARE_R2_ENDPOINT',
  );
  static const String cloudflareR2AccessKeyId = String.fromEnvironment(
    'CLOUDFLARE_R2_ACCESS_KEY_ID',
  );
  static const String cloudflareR2SecretAccessKey = String.fromEnvironment(
    'CLOUDFLARE_R2_SECRET_ACCESS_KEY',
  );
  static const String cloudflareR2BucketName = String.fromEnvironment(
    'CLOUDFLARE_R2_BUCKET_NAME',
  );
}
