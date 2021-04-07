import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pizaato/AdminPanel/Services/DeliveryOptions.dart';
import 'package:provider/provider.dart';

class AdminDetailHeplers with ChangeNotifier {
  GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  initMarker(collection, collectionId) {
    var varMarkerId = collectionId;
    final MarkerId markerId = MarkerId(varMarkerId);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
            collection['location'].latitude, collection['location'].longitude),
        infoWindow: InfoWindow(title: 'Order', snippet: collection['address']));
    markers[markerId] = marker;
  }

  getMarkerData(String collection) async {
    FirebaseFirestore.instance.collection(collection).get().then((docData) {
      if (docData.docs.isNotEmpty) {
        for (int i = 0; i < docData.docs.length; i++) {
          initMarker(docData.docs[i].data(), docData.docs[i].id);
          print(docData.docs[i].data());
        }
      }
    });
  }

  showGoogleMaps(BuildContext context, DocumentSnapshot documentSnapshot) {
    return GoogleMap(
      mapType: MapType.hybrid,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      mapToolbarEnabled: true,
      buildingsEnabled: true,
      initialCameraPosition: CameraPosition(
        zoom: 17,
        tilt: 1.0,
        target: LatLng(documentSnapshot.data()['location'].latitude,
            documentSnapshot.data()['location'].longitude),
      ),
      onMapCreated: (GoogleMapController mapController) {
        googleMapController = mapController;
        notifyListeners();
      },
    );
  }

  detailSheet(BuildContext context, DocumentSnapshot documentSnapshot,
      String collection) {
    getMarkerData(collection);
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4.0,
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          EvaIcons.person,
                          color: Colors.red,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            documentSnapshot.data()['username'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.mapPin,
                            color: Colors.lightBlueAccent,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 8),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 360.0),
                              child: Text(
                                documentSnapshot.data()['address'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 400,
                    width: 400,
                    child: showGoogleMaps(context, documentSnapshot),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 30, bottom: 2),
                  alignment: Alignment.center,
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              documentSnapshot.data()['time'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.rupeeSign,
                            color: Colors.white,
                          ),
                          Text(
                            documentSnapshot.data()['price'].toString(),
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              documentSnapshot.data()['image'],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                'Pizza : ${documentSnapshot.data()['pizza']}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Cheese : ${documentSnapshot.data()['cheese']},',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Onion : ${documentSnapshot.data()['onion']},',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Beacon : ${documentSnapshot.data()['beacon']}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              documentSnapshot.data()['size'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Container(
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<DeliveryOptions>(context, listen: false)
                                .manageOrders(context, documentSnapshot,
                                    'cancelledOrders', 'Delivery Cancelled');
                          },
                          icon: Icon(FontAwesomeIcons.eye, color: Colors.white),
                          label: Text(
                            'Skip',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<DeliveryOptions>(context, listen: false)
                                .manageOrders(context, documentSnapshot,
                                    'deliveredOrders', 'Delivery Accepted');
                          },
                          icon: Icon(FontAwesomeIcons.delicious,
                              color: Colors.white),
                          label: Text(
                            'Deliver',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.phone, color: Colors.white),
                    label: Text(
                      'Contact the owner',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.97,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Color(0xff200B4B)),
          );
        });
  }
}
