import 'package:dotto/helper/logger.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<bool> launchUrlSafely(
  String url, {
  LaunchMode mode = .platformDefault,
}) async {
  try {
    return await launchUrlString(url, mode: mode);
  } on Exception catch (error, stack) {
    await LoggerImpl().logError(error, stack);
    return false;
  }
}
