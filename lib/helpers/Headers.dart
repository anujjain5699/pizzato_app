import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pizaato/views/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Headers extends ChangeNotifier {
  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.remove('uid');
              print("~~~~~~~ User signout ~~~~~~");
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: Login(), type: PageTransitionType.leftToRight));
            }),
      ],
      title: Text(
        'Home',
        style: TextStyle(
            color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget headerText() {
    return Container(
      constraints: BoxConstraints(maxWidth: 250.0),
      child: RichText(
          text: TextSpan(
              text: 'What would you like\n',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontSize: 28.0),
              children: [
            TextSpan(
                text: 'to eat?',
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.greenAccent,
                ))
          ])),
    );
  }

  Widget headerMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.redAccent, blurRadius: 5.0),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  color: Colors.grey.shade300),
              height: 40.0,
              width: 100.0,
              child: Center(
                child: Text(
                  'All Food',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.greenAccent, blurRadius: 5.0),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  color: Colors.grey.shade300),
              height: 40.0,
              width: 100.0,
              child: Center(
                child: Text(
                  'Pasta',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.blueAccent, blurRadius: 10.0),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  color: Colors.grey.shade300),
              height: 40.0,
              width: 100.0,
              child: Center(
                child: Text(
                  'Pizza',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
