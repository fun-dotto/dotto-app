import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hope_continuation_user_key_controller.g.dart';

@riverpod
final class HopeContinuationUserKeyNotifier extends _$HopeContinuationUserKeyNotifier {
  @override
  Future<String> build() async {
    return await UserPreferenceRepository.getString(UserPreferenceKeys.userKey) ?? '';
  }

  Future<void> set(String userKey) async {
    final userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
    if (userKey.length == 16 && userKeyPattern.hasMatch(userKey)) {
      await UserPreferenceRepository.setString(UserPreferenceKeys.userKey, userKey);
      return;
    }
    if (userKey.isEmpty) {
      await UserPreferenceRepository.setString(UserPreferenceKeys.userKey, userKey);
    }
  }
}
