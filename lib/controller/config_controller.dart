import 'dart:async';

import 'package:dotto/domain/breaking_announcement.dart';
import 'package:dotto/domain/config.dart';
import 'package:dotto/domain/remote_config_keys.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/remote_config_helper.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_controller.g.dart';

@Riverpod(keepAlive: true)
final class ConfigNotifier extends _$ConfigNotifier {
  bool? _isV2EnabledOverride;
  bool? _isFunchEnabledOverride;
  bool _didStartLoadingOverride = false;

  bool? get isV2EnabledOverride => _isV2EnabledOverride;
  bool? get isFunchEnabledOverride => _isFunchEnabledOverride;

  @override
  Config build() {
    if (!_didStartLoadingOverride) {
      _didStartLoadingOverride = true;
      unawaited(loadOverrides());
    }

    final remoteConfigRepository = ref.read(remoteConfigHelperProvider);
    final remoteConfigIsV2Enabled = remoteConfigRepository.getBool(RemoteConfigKeys.isV2Enabled);
    final remoteConfigIsFunchEnabled = remoteConfigRepository.getBool(RemoteConfigKeys.isFunchEnabled);
    final isV2Enabled = _isV2EnabledOverride ?? remoteConfigIsV2Enabled;
    final isFunchEnabled = _isFunchEnabledOverride ?? remoteConfigIsFunchEnabled;
    final validAppVersion = remoteConfigRepository.getString(RemoteConfigKeys.validAppVersion);
    final latestAppVersion = remoteConfigRepository.getString(RemoteConfigKeys.latestAppVersion);
    final isUnderMaintenance = remoteConfigRepository.getBool(RemoteConfigKeys.isUnderMaintenance);
    final feedbackFormUrl = remoteConfigRepository.getString(RemoteConfigKeys.feedbackFormUrl);
    final termsOfServiceUrl = remoteConfigRepository.getString(RemoteConfigKeys.termsOfServiceUrl);
    final privacyPolicyUrl = remoteConfigRepository.getString(RemoteConfigKeys.privacyPolicyUrl);
    final appStorePageUrl = remoteConfigRepository.getString(RemoteConfigKeys.appStorePageUrl);
    final officialCalendarPdfUrl = remoteConfigRepository.getString(RemoteConfigKeys.officialCalendarPdfUrl);
    final timetable1PdfUrl = remoteConfigRepository.getString(RemoteConfigKeys.timetable1PdfUrl);
    final timetable2PdfUrl = remoteConfigRepository.getString(RemoteConfigKeys.timetable2PdfUrl);
    final dottoWebUrl = remoteConfigRepository.getString(RemoteConfigKeys.dottoWebUrl);
    final macSupportDeskUrl = remoteConfigRepository.getString(RemoteConfigKeys.macSupportDeskUrl);

    final breakingAnnouncementJson = remoteConfigRepository.getJSON(RemoteConfigKeys.breakingAnnouncement);
    final breakingAnnouncementTitle = breakingAnnouncementJson['title'] as String?;
    final breakingAnnouncementUrl = breakingAnnouncementJson['url'] as String?;
    final breakingAnnouncementIsExternal = breakingAnnouncementJson['is_external'] as bool?;
    BreakingAnnouncement? breakingAnnouncement;
    if (breakingAnnouncementTitle != null &&
        breakingAnnouncementUrl != null &&
        breakingAnnouncementIsExternal != null) {
      breakingAnnouncement = BreakingAnnouncement(
        title: breakingAnnouncementTitle,
        url: breakingAnnouncementUrl,
        isExternal: breakingAnnouncementIsExternal,
      );
    }

    return Config(
      isV2Enabled: isV2Enabled,
      isFunchEnabled: isFunchEnabled,
      validAppVersion: validAppVersion,
      latestAppVersion: latestAppVersion,
      isUnderMaintenance: isUnderMaintenance,
      feedbackFormUrl: feedbackFormUrl,
      termsOfServiceUrl: termsOfServiceUrl,
      privacyPolicyUrl: privacyPolicyUrl,
      appStorePageUrl: appStorePageUrl,
      officialCalendarPdfUrl: officialCalendarPdfUrl,
      timetable1PdfUrl: timetable1PdfUrl,
      timetable2PdfUrl: timetable2PdfUrl,
      breakingAnnouncement: breakingAnnouncement,
      dottoWebUrl: dottoWebUrl,
      macSupportDeskUrl: macSupportDeskUrl,
    );
  }

  void refresh() {
    state = build();
  }

  Future<void> loadOverrides() async {
    await Future.wait([
      _loadIsV2EnabledOverride(refreshAfterLoad: false),
      _loadIsFunchEnabledOverride(refreshAfterLoad: false),
    ]);
    refresh();
  }

  Future<void> loadIsV2EnabledOverride() async {
    await _loadIsV2EnabledOverride(refreshAfterLoad: true);
  }

  Future<void> setIsV2EnabledOverride({required bool? value}) async {
    _isV2EnabledOverride = value;
    if (value == null) {
      await UserPreferenceRepository.remove(UserPreferenceKeys.isV2EnabledOverride);
    } else {
      await UserPreferenceRepository.setBool(UserPreferenceKeys.isV2EnabledOverride, value: value);
    }
    refresh();
  }

  Future<void> loadIsFunchEnabledOverride() async {
    await _loadIsFunchEnabledOverride(refreshAfterLoad: true);
  }

  Future<void> setIsFunchEnabledOverride({required bool? value}) async {
    _isFunchEnabledOverride = value;
    if (value == null) {
      await UserPreferenceRepository.remove(UserPreferenceKeys.isFunchEnabledOverride);
    } else {
      await UserPreferenceRepository.setBool(UserPreferenceKeys.isFunchEnabledOverride, value: value);
    }
    refresh();
  }

  Future<void> _loadIsV2EnabledOverride({required bool refreshAfterLoad}) async {
    _isV2EnabledOverride = await UserPreferenceRepository.getBool(UserPreferenceKeys.isV2EnabledOverride);
    if (refreshAfterLoad) {
      refresh();
    }
  }

  Future<void> _loadIsFunchEnabledOverride({required bool refreshAfterLoad}) async {
    _isFunchEnabledOverride = await UserPreferenceRepository.getBool(UserPreferenceKeys.isFunchEnabledOverride);
    if (refreshAfterLoad) {
      refresh();
    }
  }
}
