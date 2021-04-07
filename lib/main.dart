import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pizaato/AdminPanel/Services/AdminDetailHelpers.dart';
import 'package:pizaato/AdminPanel/Services/DeliveryOptions.dart';
import 'package:pizaato/Providers/Authentication.dart';
import 'package:pizaato/Providers/Calculations.dart';
import 'package:pizaato/Providers/Payment.dart';
import 'package:pizaato/helpers/Footers.dart';
import 'package:pizaato/helpers/Headers.dart';
import 'package:pizaato/helpers/Middle.dart';
import 'package:pizaato/services/ManageData.dart';
import 'package:pizaato/services/ManageMaps.dart';
import 'package:pizaato/views/splashscreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value:DeliveryOptions()),
          ChangeNotifierProvider.value(value: AdminDetailHeplers()),
          ChangeNotifierProvider.value(value: PaymentHelper()),
          ChangeNotifierProvider.value(value: Headers()),
          ChangeNotifierProvider.value(value: MiddleHelpers()),
          ChangeNotifierProvider.value(value: ManageData()),
          ChangeNotifierProvider.value(value: Footers()),
          ChangeNotifierProvider.value(value: GenerateMaps()),
          ChangeNotifierProvider.value(value: Authentication()),
          ChangeNotifierProvider.value(value: Calculations()),
        ],
        child: MaterialApp(
            title: 'Pizaato',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              canvasColor: Colors.transparent,
                primarySwatch: Colors.red,
                primaryColor: Colors.redAccent,
                visualDensity: VisualDensity.adaptivePlatformDensity),
            home: SplashScreen()));
  }
}
