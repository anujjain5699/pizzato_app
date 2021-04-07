import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pizaato/services/ManageMaps.dart';
import 'package:pizaato/views/Mycart.dart';
import 'package:provider/provider.dart';

class Maps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Provider.of<GenerateMaps>(context, listen: false).fetchMaps(),
            Positioned(
                bottom: MediaQuery.of(context).size.height * 0.01,
                left: MediaQuery.of(context).size.width * 0.40,
                child: MaterialButton(
                  color: Colors.black,
                  onPressed: () {
                    bottom(context);
                  },
                  child: Text(
                    'Address',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
            Positioned(
                top: 50.0,
                left: 10,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    autofocus: true,
                    icon: Icon(
                      Icons.arrow_back_ios,
                    ),
                    color: Colors.black,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: MyCart(), type: PageTransitionType.fade));
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }

  bottom(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.green, blurRadius: 1, spreadRadius: 1)
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Color(0xffece4db)),
            alignment: Alignment.center,
            height: 100.0,
            child: Center(
              child: Text(
                Provider.of<GenerateMaps>(context, listen: true).getMainAddress,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
            ),
          );
        });
  }
}
