import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pizaato/Decider.dart';
import 'package:pizaato/views/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userUid,userEmail;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userUid = sharedPreferences.getString('uid');
    userEmail=sharedPreferences.getString('useremail');
    print("~~~~~~userUid: $userUid ~~~~~~");
  }

  @override
  void initState() {
    getUid().whenComplete(() {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              PageTransition(
                  child: userUid == null ? Decider() : HomeScreen( ),
                  type: PageTransitionType.leftToRightWithFade)));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300.0,
              width: 600.0,
              child: Lottie.asset('animation/pizza_loading.json'),
            ),
            RichText(
              text: TextSpan(
                  text: 'Piz',
                  style: TextStyle(
                    fontSize: 56.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'z',
                      style: TextStyle(
                        fontSize: 56.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'ato',
                      style: TextStyle(
                        fontSize: 56.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
