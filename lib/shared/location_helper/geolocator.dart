
import 'package:geolocator/geolocator.dart';


class LocationHelper{

  static Future<Position> getCurrentLocation ()async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission= await Geolocator.checkPermission();
    if(!isServiceEnabled){
      await Geolocator.openLocationSettings();
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

  }
}