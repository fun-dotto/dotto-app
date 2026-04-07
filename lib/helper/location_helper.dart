import 'package:geolocator/geolocator.dart';

abstract class LocationHelper {
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
