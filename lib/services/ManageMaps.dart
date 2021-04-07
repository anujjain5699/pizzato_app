import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GenerateMaps extends ChangeNotifier {
  Position position;
  Position get getPosition => position;
  String finalAddress = 'Searching Address..';
  String get getFinalAddress => finalAddress;
  GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GeoPoint geoPoint;
  GeoPoint get getGeoPoint => geoPoint;
  String countryName, mainAddress = "hey,address here";
  String get getCountryName => countryName;
  String get getMainAddress => mainAddress;

  Future getCurrentLocation() async {
    var positionData = await GeolocatorPlatform.instance.getCurrentPosition();
    final coordinates =
        geoCo.Coordinates(positionData.latitude, positionData.longitude);
    var address =
        await geoCo.Geocoder.local.findAddressesFromCoordinates(coordinates);
    String mainAddress = address.first.addressLine;
    print(">>>>>>>>>>>>>>>>>>>>>>>>main address : ");
    print(mainAddress);
    finalAddress = mainAddress;
    print("\n>>>>>>>>>>>>>>>>>>>>>>>>final address : ");
    print(finalAddress);
    notifyListeners();
  }

  getMarkers(double lat, double lng) {
    MarkerId markerId = MarkerId(lat.toString() + lng.toString());
    Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: getMainAddress, snippet: 'Country name'));
    markers[markerId] = marker;
  }

  Widget fetchMaps() {
    return GoogleMap(
      mapType: MapType.hybrid,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onTap: (loc) async {
        final coords = geoCo.Coordinates(loc.latitude, loc.longitude);
        var address =
            await geoCo.Geocoder.local.findAddressesFromCoordinates(coords);
        countryName = address.first.countryName;
        mainAddress = address.first.addressLine;
        geoPoint = GeoPoint(loc.latitude, loc.longitude);
        notifyListeners();
        markers == null
            ? getMarkers(loc.latitude, loc.longitude)
            : markers.clear();
        print("____loc____: $loc");
        print("countryname ___: $countryName");
        print("__mainaddress__$mainAddress");
      },
      markers: Set<Marker>.of(markers.values),
      onMapCreated: (GoogleMapController mapController) {
        googleMapController = mapController;
        notifyListeners();
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(21.000, 45.0000), zoom: 18.0),
    );
  }
}
