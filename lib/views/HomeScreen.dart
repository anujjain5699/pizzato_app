import 'package:flutter/material.dart';
import 'package:pizaato/helpers/Footers.dart';
import 'package:pizaato/helpers/Headers.dart';
import 'package:pizaato/helpers/Middle.dart';
import 'package:pizaato/services/ManageMaps.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<GenerateMaps>(context, listen: false).getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.45,
          drawer: Drawer(),
          floatingActionButton: Footers().floatingActionButton(context),
          backgroundColor: Color(0xffFDFDFF),
          body: SingleChildScrollView(
            child: Container(
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
                    ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Headers().appBar(context),
                    Headers().headerText(),
                    Headers().headerMenu(context),
                    MiddleHelpers().textFav(),
                    MiddleHelpers().dataFav(context, 'favourite'),
                    MiddleHelpers().textBusiness(),
                    MiddleHelpers().dataBusiness(context, 'business'),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
