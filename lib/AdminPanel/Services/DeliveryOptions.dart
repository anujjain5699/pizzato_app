import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pizaato/AdminPanel/Services/AdminDetailHelpers.dart';
import 'package:provider/provider.dart';

class DeliveryOptions with ChangeNotifier {
  showOrders(BuildContext context, String collection) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Color(0xff200B4B),
            ),
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(collection)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Color(0xff200B4B),
                      ),
                      child: new ListView(
                        shrinkWrap: true,
                        children: snapshot.data.docs
                            .map((DocumentSnapshot documentSnapshot) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              trailing: IconButton(
                                icon: Icon(FontAwesomeIcons.mapPin),
                                onPressed: () {
                                  showMap(
                                      context, documentSnapshot, collection);
                                },
                                color: Colors.green,
                              ),
                              subtitle: Text(
                                documentSnapshot.data()['name'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              horizontalTitleGap: 5,
                              title: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white,
                                    )),
                                child: Text(
                                  documentSnapshot.data()['address'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    documentSnapshot.data()['image']),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                }),
          );
        });
  }

  Future manageOrders(BuildContext context, DocumentSnapshot documentSnapshot,
      String collection, String message) async {
    await FirebaseFirestore.instance.collection(collection).add({
      'image': documentSnapshot.data()['image'],
      'name': documentSnapshot.data()['username'],
      'pizza': documentSnapshot.data()['pizza'],
      'address': documentSnapshot.data()['address'],
      'location': documentSnapshot.data()['location']
    }).whenComplete(() {
      showMessage(context, message);
    });
  }

  showMap(BuildContext context, DocumentSnapshot documentSnapshot,
      String collection) {
    Provider.of<AdminDetailHeplers>(context, listen: false)
        .getMarkerData(collection)
        .whenComplete(() {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.50,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: MediaQuery.of(context).size.height * 0.48,
                    child:
                        Provider.of<AdminDetailHeplers>(context, listen: false)
                            .showGoogleMaps(context, documentSnapshot),
                  ),
                ],
              ),
            );
          });
    });
  }

  showMessage(BuildContext context, String message) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Color(0xff200B4B)),
            height: 50,
            width: 400,
            child: Center(
              child: Text(
                message,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          );
        });
  }
}
