import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pizaato/Providers/Authentication.dart';
import 'package:pizaato/Providers/Calculations.dart';
import 'package:pizaato/Providers/Payment.dart';
import 'package:pizaato/services/ManageData.dart';
import 'package:pizaato/services/ManageMaps.dart';
import 'package:pizaato/views/HomeScreen.dart';
import 'package:pizaato/views/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  Razorpay razorpay;
  int price = 400;
  int total = 420;

  @override
  void initState() {
    razorpay = Razorpay();
    razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        Provider.of<PaymentHelper>(context, listen: false)
            .handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        Provider.of<PaymentHelper>(context, listen: false).handlePaymentError);
    razorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        Provider.of<PaymentHelper>(context, listen: false)
            .handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  Future checkMeOut() async {
    var options = {
      'key': 'Api_key_here',
      'amount': total,
      'name':
          Provider.of<Authentication>(context, listen: false).getEmail == null
              ? userEmail
              : Provider.of<Authentication>(context, listen: false).getEmail,
      'description': 'Payment',
      'prefill': {
        'contact': '9999999999',
        'email': Provider.of<Authentication>(context, listen: false).getEmail,
      },
      'external': {
        'wallet': ['paytm']
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
              0.2,
              0.45,
              0.6,
              0.9
            ],
                colors: [
              Color(0xff200B4B),
              Color(0xff201F22),
              Color(0xff1A1031),
              Color(0xff19181F),
            ])),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appbBar(context),
              // headerText(),
              cartData(),
              Spacer(),
              Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  child:
                      Lottie.asset('animation/dark.json', fit: BoxFit.cover)),
            ],
          ),
        ),
      ),
    );
  }

  Widget appbBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomeScreen(),
                      type: PageTransitionType.rightToLeftWithFade));
            },
          ),
          headerText(),
          Spacer(),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.trash,
              color: Colors.red,
            ),
            onPressed: () async {
              Provider.of<ManageData>(context, listen: false)
                  .deleteData(context);
              Provider.of<Calculations>(context, listen: false).cartData = 0;
            },
          ),
        ],
      ),
    );
  }

  Widget headerText() {
    return Column(
      children: [
        Text(
          "Your",
          style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        Text(
          ' Cart',
          style: TextStyle(
              color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget cartData() {
    return SizedBox(
      height: 450.0,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('myOrders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          } else {
            return new ListView(
                shrinkWrap: true,
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  return GestureDetector(
                    onLongPress: () {
                      placeOrder(context, documentSnapshot);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: Colors.grey[500]),
                              BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: Colors.red[100]),
                            ]),
                        height: 180,
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                documentSnapshot.data()['image'],
                                height: 150,
                                width: 180,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  return loadingProgress == null
                                      ? child
                                      : Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                          ),
                                        );
                                },
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    documentSnapshot.data()['name'],
                                    minFontSize: 18,
                                    maxFontSize: 20,
                                    style: TextStyle(
                                        decorationStyle:
                                            TextDecorationStyle.dashed,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Price :",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 21.0),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.rupeeSign,
                                        color: Colors.grey,
                                        size: 21,
                                      ),
                                      Text(
                                        "${documentSnapshot.data()['price'].toString()}",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 21.0),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Onion :${documentSnapshot.data()['onion'].toString()}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  Text(
                                    "Beacon :${documentSnapshot.data()['beacon'].toString()}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  Text(
                                    "Cheese :${documentSnapshot.data()['cheese'].toString()}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.pink[500],
                                    child: Text(
                                      documentSnapshot.data()['size'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList());
          }
        },
      ),
    );
  }

  Widget floatingActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Provider.of<Authentication>(context, listen: false).getUid == null
                ? print("~~~~~ shared userUid : $userUid")
                : print(
                    Provider.of<Authentication>(context, listen: false).getUid);
          },
          child: Container(
            width: 250.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.red.shade500,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Center(
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }

  placeOrder(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    color: Colors.white,
                    thickness: 4.0,
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30.0,
                          child: Text(
                            'Time : ${Provider.of<PaymentHelper>(context, listen: true).deliveryTiming.format(context)} ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        Container(
                          height: 80.0,
                          child: AutoSizeText(
                            'Location : ${Provider.of<GenerateMaps>(context, listen: true).getMainAddress}',
                            minFontSize: 15,
                            maxFontSize: 18,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        Provider.of<PaymentHelper>(context, listen: false)
                            .selectTime(context);
                      },
                      backgroundColor: Colors.redAccent,
                      child: Icon(FontAwesomeIcons.clock, color: Colors.white),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Provider.of<PaymentHelper>(context, listen: false)
                            .selectLocation(context);
                      },
                      backgroundColor: Colors.lightBlueAccent,
                      child: Icon(FontAwesomeIcons.mapMarkerAlt,
                          color: Colors.white),
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        await checkMeOut().whenComplete(() {
                          Provider.of<PaymentHelper>(context, listen: false)
                              .showCheckoutButtonMethod();
                        });
                      },
                      backgroundColor: Colors.lightGreenAccent,
                      child:
                          Icon(FontAwesomeIcons.paypal, color: Colors.black54),
                    ),
                  ],
                ),
                Provider.of<PaymentHelper>(context, listen: false)
                        .showCheckoutButton
                    ? MaterialButton(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Place Order',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('adminCollections')
                              .add({
                            'location': Provider.of<GenerateMaps>(context,
                                    listen: false)
                                .geoPoint,
                            'username': Provider.of<Authentication>(context,
                                            listen: false)
                                        .getEmail ==
                                    null
                                ? userEmail
                                : Provider.of<Authentication>(context,
                                        listen: false)
                                    .getEmail,
                            'image': documentSnapshot.data()['image'],
                            'pizza': documentSnapshot.data()['name'],
                            'price': documentSnapshot.data()['price'],
                            'time': Provider.of<PaymentHelper>(context,
                                    listen: false)
                                .deliveryTiming
                                .format(context),
                            'address': Provider.of<GenerateMaps>(context,
                                    listen: false)
                                .getMainAddress,
                            'size': documentSnapshot.data()['size'],
                            'onion': documentSnapshot.data()['onion'],
                            'cheese': documentSnapshot.data()['cheese'],
                            'beacon': documentSnapshot.data()['beacon']
                          });
                        },
                      )
                    : Container()
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xff191531)),
          );
        });
  }
}
