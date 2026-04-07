final class AppVersionEvaluation {
  const AppVersionEvaluation({
    required this.isValidAppVersion,
    required this.isLatestAppVersion,
  });

  final bool isValidAppVersion;
  final bool isLatestAppVersion;
}

final class AppVersionEvaluator {
  static AppVersionEvaluation evaluate({
    required String currentAppVersion,
    required String validAppVersion,
    required String latestAppVersion,
  }) {
    final current = _parseVersion(currentAppVersion);
    if (current == null) {
      return const AppVersionEvaluation(
        isValidAppVersion: true,
        isLatestAppVersion: true,
      );
    }

    final valid = _parseVersion(validAppVersion);
    final latest = _parseVersion(latestAppVersion);

    final isValid = valid == null ? true : _compare(current, valid) >= 0;
    final isLatest = latest == null ? true : _compare(current, latest) >= 0;

    return AppVersionEvaluation(
      isValidAppVersion: isValid,
      isLatestAppVersion: isLatest,
    );
  }

  static List<int>? _parseVersion(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parts = trimmed.split('.');
    final parsed = <int>[];
    for (final part in parts) {
      final match = RegExp(r'^\d+').firstMatch(part.trim());
      if (match == null) {
        return null;
      }
      parsed.add(int.parse(match.group(0)!));
    }
    return parsed;
  }

  static int _compare(List<int> left, List<int> right) {
    final maxLength = left.length > right.length ? left.length : right.length;
    for (var i = 0; i < maxLength; i++) {
      final l = i < left.length ? left[i] : 0;
      final r = i < right.length ? right[i] : 0;
      if (l != r) {
        return l > r ? 1 : -1;
      }
    }
    return 0;
  }
}
