import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pizaato/AdminPanel/Services/AdminDetailHelpers.dart';
import 'package:pizaato/AdminPanel/Services/DeliveryOptions.dart';
import 'package:pizaato/AdminPanel/Views/LoginPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: floatingActionButton(context),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 0.45, 0.6, 0.9],
                colors: [
                  Color(0xFF4FC684),
                  Color(0xFF226E94),
                  Color(0xFFBB3C80),
                  Color(0xff19181F),
                ],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.red,
        onRefresh: () async {
          print(">>>>>>..........Refreshed");
        },
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.45, 0.6, 0.9],
                  colors: [
                    Color(0xff200B4B),
                    Color(0xff201F22),
                    Color(0xff1A1031),
                    Color(0xff19181F),
                  ],
                ),
              ),
            ),
            appBar(context),
            timeChips(context),
            orderData(context),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.remove('uid');
              print("~~~~~~~ Admin___User signout ~~~~~~");
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: AdminLogin(),
                      type: PageTransitionType.leftToRight));
            }),
      ],
      centerTitle: true,
      title: Text(
        'Orders',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget timeChips(BuildContext context) {
    return Positioned(
      top: 100.0,
      child: Container(
        width: 400.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionChip(
              backgroundColor: Colors.purple[400],
              label: Text(
                'Today',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
            ActionChip(
              backgroundColor: Colors.purple[400],
              label: Text(
                'This Week',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
            ActionChip(
              backgroundColor: Colors.purple[400],
              label: Text(
                'This Month',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget orderData(BuildContext context) {
    return Positioned(
      top: 150,
      child: SizedBox(
        height: 600,
        width: 400,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('adminCollections')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                      ),
                      child: ListTile(
                        onTap: () {
                          Provider.of<AdminDetailHeplers>(context,
                                  listen: false)
                              .detailSheet(context, documentSnapshot,
                                  'adminCollections');
                        },
                        contentPadding: EdgeInsets.all(8),
                        trailing: IconButton(
                            icon: Icon(FontAwesomeIcons.magento,
                                color: Colors.white),
                            onPressed: () {}),
                        subtitle: Text(
                          documentSnapshot.data()['address'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400),
                        ),
                        title: Text(
                          documentSnapshot.data()['pizza'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            documentSnapshot.data()['image'],
                          ),
                          backgroundColor: Colors.transparent,
                          radius: 25.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget floatingActionButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          child: Icon(
            Icons.cancel_outlined,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Provider.of<DeliveryOptions>(context, listen: false)
                .showOrders(context, 'cancelledOrders');
          },
        ),
        FloatingActionButton(
          child: Icon(
            FontAwesomeIcons.check,
            color: Colors.white,
          ),
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            Provider.of<DeliveryOptions>(context, listen: false)
                .showOrders(context, 'deliveredOrders');
          },
        )
      ],
    );
  }
}
