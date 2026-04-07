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
  bool? _isFunchEnabledOverride;
  bool _didStartLoadingOverride = false;

  bool? get isFunchEnabledOverride => _isFunchEnabledOverride;

  @override
  Config build() {
    if (!_didStartLoadingOverride) {
      _didStartLoadingOverride = true;
      unawaited(loadOverrides());
    }

    final remoteConfigRepository = ref.read(remoteConfigHelperProvider);
    final remoteConfigIsFunchEnabled = remoteConfigRepository.getBool(
      RemoteConfigKeys.isFunchEnabled,
    );
    final isFunchEnabled =
        _isFunchEnabledOverride ?? remoteConfigIsFunchEnabled;
    final validAppVersion = remoteConfigRepository.getString(
      RemoteConfigKeys.validAppVersion,
    );
    final latestAppVersion = remoteConfigRepository.getString(
      RemoteConfigKeys.latestAppVersion,
    );
    final isUnderMaintenance = remoteConfigRepository.getBool(
      RemoteConfigKeys.isUnderMaintenance,
    );
    final feedbackFormUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.feedbackFormUrl,
    );
    final termsOfServiceUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.termsOfServiceUrl,
    );
    final privacyPolicyUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.privacyPolicyUrl,
    );
    final appStorePageUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.appStorePageUrl,
    );
    final officialCalendarPdfUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.officialCalendarPdfUrl,
    );
    final timetable1PdfUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.timetable1PdfUrl,
    );
    final timetable2PdfUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.timetable2PdfUrl,
    );
    final dottoWebUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.dottoWebUrl,
    );
    final macSupportDeskUrl = remoteConfigRepository.getString(
      RemoteConfigKeys.macSupportDeskUrl,
    );

    final breakingAnnouncementJson = remoteConfigRepository.getJSON(
      RemoteConfigKeys.breakingAnnouncement,
    );
    final breakingAnnouncementTitle = _asStringOrNull(
      breakingAnnouncementJson['title'],
    );
    final breakingAnnouncementUrl = _asStringOrNull(
      breakingAnnouncementJson['url'],
    );
    final breakingAnnouncementIsExternal = _asBoolOrNull(
      breakingAnnouncementJson['is_external'],
    );
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
    await _loadIsFunchEnabledOverride(refreshAfterLoad: false);
    refresh();
  }

  Future<void> loadIsFunchEnabledOverride() async {
    await _loadIsFunchEnabledOverride(refreshAfterLoad: true);
  }

  Future<void> setIsFunchEnabledOverride({required bool? value}) async {
    _isFunchEnabledOverride = value;
    if (value == null) {
      await UserPreferenceRepository.remove(
        UserPreferenceKeys.isFunchEnabledOverride,
      );
    } else {
      await UserPreferenceRepository.setBool(
        UserPreferenceKeys.isFunchEnabledOverride,
        value: value,
      );
    }
    refresh();
  }

  Future<void> _loadIsFunchEnabledOverride({
    required bool refreshAfterLoad,
  }) async {
    _isFunchEnabledOverride = await UserPreferenceRepository.getBool(
      UserPreferenceKeys.isFunchEnabledOverride,
    );
    if (refreshAfterLoad) {
      refresh();
    }
  }

  String? _asStringOrNull(Object? value) {
    return value is String ? value : null;
  }

  bool? _asBoolOrNull(Object? value) {
    return value is bool ? value : null;
  }
}
