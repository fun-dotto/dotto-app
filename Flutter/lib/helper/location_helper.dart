import 'package:geolocator/geolocator.dart';

abstract class LocationHelper {
  static const double _universityLat = 41.8419;
  static const double _universityLng = 140.7667;
  static const double _nearThresholdMeters = 500;

  static Future<bool> isNearUniversity() async {
    try {
      final position =
          await determinePosition().timeout(const Duration(seconds: 5));
      if (position == null) return false;
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _universityLat,
        _universityLng,
      );
      return distance <= _nearThresholdMeters;
    } on Exception catch (_) {
      return false;
    }
  }

  static Future<bool> requestLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }

    switch (await Geolocator.checkPermission()) {
      case .denied:
        switch (await Geolocator.requestPermission()) {
          case .denied:
            return false;
          case .deniedForever:
            return false;
          case .whileInUse:
            return true;
          case .always:
            return true;
          case .unableToDetermine:
            return true;
        }
      case .deniedForever:
        return false;
      case .whileInUse:
        return true;
      case .always:
        return true;
      case .unableToDetermine:
        return true;
    }
  }

  static Future<Position?> determinePosition() async {
    if (await requestLocationPermission()) {
      return Geolocator.getCurrentPosition();
    } else {
      return null;
    }
  }
}
