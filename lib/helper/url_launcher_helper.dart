import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<bool> launchUrlSafely(String url, {LaunchMode mode = .platformDefault}) async {
  try {
    return await launchUrlString(url, mode: mode);
  } on Exception catch (e) {
    debugPrint('Failed to launch URL: $url ($e)');
    return false;
  }
}
