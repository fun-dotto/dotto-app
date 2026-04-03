final class RemoteConfigKeys {
  /// v2 feature flag
  static const String isV2Enabled = 'is_v2_enabled';

  /// Funch feature flag
  static const String isFunchEnabled = 'is_funch_enabled';

  /// サポート対象の最小バージョン
  ///
  /// 現在のアプリバージョンがこの値より小さい場合: 強制アップデート対象
  ///
  /// アプリストアへの遷移のみ可能な画面が表示されるようにし、アプリの一切の機能を利用できないようにする
  ///
  /// ただし、オフラインの場合は、バイパスする
  static const String validAppVersion = 'valid_app_version';

  /// 最新のアプリバージョン
  ///
  /// 現在のアプリバージョンがこの値より小さい場合: アップデートのお知らせを表示
  ///
  /// オフラインの場合は、バイパスする
  static const String latestAppVersion = 'latest_app_version';

  /// メンテナンスモード
  static const String isUnderMaintenance = 'is_under_maintenance';

  /// フィードバックフォームURL
  static const String feedbackFormUrl = 'feedback_form_url';

  /// 利用規約URL
  static const String termsOfServiceUrl = 'terms_of_service_url';

  /// プライバシーポリシーURL
  static const String privacyPolicyUrl = 'privacy_policy_url';

  /// アプリストアURL
  static const String appStorePageUrl = 'app_store_page_url';

  /// 学年暦PDF URL
  static const String officialCalendarPdfUrl = 'official_calendar_pdf_url';

  /// 時間割 (前期) PDF URL
  static const String timetable1PdfUrl = 'timetable_1_pdf_url';

  /// 時間割 (後期) PDF URL
  static const String timetable2PdfUrl = 'timetable_2_pdf_url';

  /// お知らせ
  static const String breakingAnnouncement = 'breaking_announcement';

  /// Dotto Web URL
  static const String dottoWebUrl = 'dotto_web_url';

  /// MacサポートデスクURL
  static const String macSupportDeskUrl = 'mac_support_desk_url';
}
