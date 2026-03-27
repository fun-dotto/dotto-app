import 'package:dotto/domain/config.dart';
import 'package:dotto/domain/remote_config_keys.dart';
import 'package:dotto/helper/remote_config_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_controller.g.dart';

@riverpod
final class ConfigNotifier extends _$ConfigNotifier {
  @override
  Config build() {
    final remoteConfigRepository = ref.read(remoteConfigHelperProvider);

    final isV2Enabled = remoteConfigRepository.getBool(RemoteConfigKeys.isV2Enabled);
    final isFunchEnabled = remoteConfigRepository.getBool(RemoteConfigKeys.isFunchEnabled);
    final isValidAppVersion = remoteConfigRepository.getBool(RemoteConfigKeys.isValidAppVersion);
    final isLatestAppVersion = remoteConfigRepository.getBool(RemoteConfigKeys.isLatestAppVersion);
    final feedbackFormUrl = remoteConfigRepository.getString(RemoteConfigKeys.feedbackFormUrl);
    final termsOfServiceUrl = remoteConfigRepository.getString(RemoteConfigKeys.termsOfServiceUrl);
    final privacyPolicyUrl = remoteConfigRepository.getString(RemoteConfigKeys.privacyPolicyUrl);
    final appStorePageUrl = remoteConfigRepository.getString(RemoteConfigKeys.appStorePageUrl);
    final officialCalendarPdfUrl = remoteConfigRepository.getString(RemoteConfigKeys.officialCalendarPdfUrl);
    final timetable1PdfUrl = remoteConfigRepository.getString(RemoteConfigKeys.timetable1PdfUrl);
    final timetable2PdfUrl = remoteConfigRepository.getString(RemoteConfigKeys.timetable2PdfUrl);

    return Config(
      isV2Enabled: isV2Enabled,
      isFunchEnabled: isFunchEnabled,
      isValidAppVersion: isValidAppVersion,
      isLatestAppVersion: isLatestAppVersion,
      feedbackFormUrl: feedbackFormUrl,
      termsOfServiceUrl: termsOfServiceUrl,
      privacyPolicyUrl: privacyPolicyUrl,
      appStorePageUrl: appStorePageUrl,
      officialCalendarPdfUrl: officialCalendarPdfUrl,
      timetable1PdfUrl: timetable1PdfUrl,
      timetable2PdfUrl: timetable2PdfUrl,
    );
  }

  void refresh() {
    state = build();
  }
}
