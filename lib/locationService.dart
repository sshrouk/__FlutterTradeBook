import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:trade_book/firebaseService.dart';
import 'package:trade_book/provider/providerdata.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationService {
  FirebaseService _service = FirebaseService();

  sendLocationToDataBase(context) async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    DocumentReference ref = _service.db
        .collection('eMarket')
        .doc(sectionID(context))
        .collection('subsection')
        .doc(subSectionID(context))
        .collection('activities')
        .doc(activitiesID(context));
    ref.update({
      'latitude': _locationData.latitude,
      'longitude': _locationData.longitude,
    });
  }

  goToMap(double latitude, double longitude) async {
    String mapLocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final String encodedUrl = Uri.encodeFull(mapLocationUrl);
    if (await canLaunch(encodedUrl)) {
      await launch(encodedUrl);
    } else {
      print('Could not launch $encodedUrl');
      throw 'Could not launch $encodedUrl';
    }
  }
}
