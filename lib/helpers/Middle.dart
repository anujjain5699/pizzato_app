import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pizaato/services/ManageData.dart';
import 'package:pizaato/views/DetailedScreen.dart';
import 'package:provider/provider.dart';

class MiddleHelpers extends ChangeNotifier {
  Widget textFav() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RichText(
          text: TextSpan(
              text: 'Favourite',
              style: TextStyle(
                  shadows: [
                    BoxShadow(color: Colors.white10, blurRadius: 1),
                  ],
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontSize: 36.0),
              children: [
            TextSpan(
                text: ' dishes',
                style: TextStyle(
                  shadows: [
                    BoxShadow(color: Colors.grey, blurRadius: 0),
                  ],
                  fontSize: 22.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade300,
                ))
          ])),
    );
  }

  Widget dataFav(BuildContext context, String collection) {
    return Container(
      height: 300.0,
      child: FutureBuilder(
        future: Provider.of<ManageData>(context, listen: false)
            .fetchData(collection),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('animation/delivery.json'),
            );
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  snapshot.data.length == null ? 0 : snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: DetailedScreen(
                              queryDocumentSnapshot: snapshot.data[index],
                            ),
                            type: PageTransitionType.topToBottom));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.lightBlueAccent,
                                blurRadius: 2,
                                spreadRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: SizedBox(
                                    height: 150.0,
                                    child: Image.network(
                                      snapshot.data[index].data()['image'],
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        return loadingProgress == null
                                            ? child
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.red,
                                                  strokeWidth: 5,
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(Colors.grey),
                                                ),
                                              );
                                      },
                                      fit: BoxFit.scaleDown,
                                      //height: 100,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 120,
                                  left: 140.0,
                                  child: IconButton(
                                      icon: Icon(
                                        EvaIcons.heart,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {}),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                snapshot.data[index].data()['name'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                snapshot.data[index].data()['category'],
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.cyan),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow.shade700,
                                      ),
                                      Text(
                                        snapshot.data[index].data()['ratings'],
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.rupeeSign,
                                          size: 12,
                                        ),
                                        Text(
                                          snapshot.data[index]
                                              .data()['price']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Widget dataBusiness(BuildContext context, String collection) {
    return Container(
      height: 400,
      child: FutureBuilder(
        future: Provider.of<ManageData>(context, listen: false)
            .fetchData(collection),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('animation/delivery.json'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.redAccent.shade100,
                                blurRadius: 5,
                                spreadRadius: 3)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data[index].data()['name'],
                                  style: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  snapshot.data[index].data()['category'],
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyan),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.rupeeSign,
                                      size: 16.0,
                                    ),
                                    Text(
                                      snapshot.data[index]
                                          .data()['notPrice']
                                          .toString(),
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.cyan),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.rupeeSign,
                                      size: 16.0,
                                    ),
                                    Text(
                                      snapshot.data[index]
                                          .data()['price']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            child: Image.network(
                              snapshot.data[index].data()['image'],
                              height: 200,
                              width: 100,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                return loadingProgress == null
                                    ? child
                                    : Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.red,
                                          strokeWidth: 5,
                                          valueColor:
                                              new AlwaysStoppedAnimation<
                                                  Color>(Colors.grey),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget textBusiness() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.0,
      ),
      child: Container(
        child: RichText(
          text: TextSpan(
            text: 'Business',
            style: TextStyle(
                shadows: [
                  BoxShadow(color: Colors.black, blurRadius: 1),
                ],
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontSize: 36.0),
            children: [
              TextSpan(
                  text: ' lunch',
                  style: TextStyle(
                    shadows: [
                      BoxShadow(color: Colors.grey, blurRadius: 0),
                    ],
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
