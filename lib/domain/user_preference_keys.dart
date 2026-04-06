enum UserPreferenceKeys {
  apiEnvironmentOverride(key: 'apiEnvironmentOverride', type: String),
  // 廃止予定
  personalTimetableListKey(key: 'personalTimetableListKey2026', type: String),
  // 廃止予定
  personalTimetableLastUpdateKey(key: 'personalTimetableLastUpdateKey', type: int),
  isAppTutorialComplete(key: 'isAppTutorialCompleted', type: bool),
  myBusStop(key: 'myBusStop', type: int),
  timetablePeriodStyle(key: 'timetablePeriodStyle', type: String),
  // 廃止予定
  isV2EnabledOverride(key: 'isV2EnabledOverride', type: bool),
  isFunchEnabledOverride(key: 'isFunchEnabledOverride', type: bool);

  const UserPreferenceKeys({required this.key, required this.type});

  final String key;
  final Type type;
}
