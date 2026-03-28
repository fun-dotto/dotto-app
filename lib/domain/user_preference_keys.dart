enum UserPreferenceKeys {
  environment(key: 'environment', type: String),
  apiEnvironmentOverride(key: 'apiEnvironmentOverride', type: String),
  grade(key: 'grade', type: String),
  course(key: 'course', type: String),
  class_(key: 'class', type: String),
  userKey(key: 'userKey', type: String),
  kadaiFinishList(key: 'finishListKey', type: String),
  kadaiAlertList(key: 'alertListKey', type: String),
  kadaiDeleteList(key: 'deleteListKey', type: String),
  personalTimetableListKey(key: 'personalTimetableListKey2026', type: String),
  personalTimetableLastUpdateKey(key: 'personalTimetableLastUpdateKey', type: int),
  isAppTutorialComplete(key: 'isAppTutorialCompleted', type: bool),
  isKadaiTutorialComplete(key: 'isKadaiTutorialCompleted', type: bool),
  myBusStop(key: 'myBusStop', type: int),
  didSaveFCMToken(key: 'didSaveFCMToken', type: bool),
  timetablePeriodStyle(key: 'timetablePeriodStyle', type: String),
  isV2EnabledOverride(key: 'isV2EnabledOverride', type: bool),
  isFunchEnabledOverride(key: 'isFunchEnabledOverride', type: bool);

  const UserPreferenceKeys({required this.key, required this.type});

  final String key;
  final Type type;
}
