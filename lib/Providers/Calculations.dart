import 'package:flutter/material.dart';
import 'package:pizaato/services/ManageData.dart';
import 'package:provider/provider.dart';

class Calculations with ChangeNotifier {
  int cheeseValue = 0, beaconValue = 0, onionValue = 0, cartData = 0;
  String size;
  String get getSize=>size;
  bool isSelected = false,
      smallTapped = false,
      mediumTapped = false,
      largeTapped = false,
      selected = false;
  int get getCheeseValue => cheeseValue;
  int get getBeaconValue => beaconValue;
  int get getOnionValue => onionValue;
  int get getCartData => cartData;
  bool get getSelected => selected;

  addCheese() {
    if(cheeseValue<10)
    cheeseValue++;
    notifyListeners();
  }

  addBeacon() {
    if(beaconValue<10)
    beaconValue++;
    notifyListeners();
  }

  addOnion() {
    if(onionValue<10)
    onionValue++;
    notifyListeners();
  }

  minusCheese() {
    if(cheeseValue<=0)
    cheeseValue=0;
    else
    cheeseValue--;
    notifyListeners();
  }

  minusBeacon() {
    if(beaconValue<=0)
    beaconValue=0;
    else
    beaconValue--;
    notifyListeners();
  }

  minusOnion() {
    if(onionValue<=0)
    onionValue=0;
    else
    onionValue--;
    notifyListeners();
  }

  selectSmallSize() {
    smallTapped = true;
    size = 'S';
    notifyListeners();
  }

  selectMediumSize() {
    mediumTapped = true;
    size = 'M';
    notifyListeners();
  }

  selectLargeSize() {
    largeTapped = true;
    size = 'L';
    notifyListeners();
  }

  removeAllData() {
    cheeseValue = 0;
    beaconValue = 0;
    onionValue = 0;
    smallTapped = false;
    mediumTapped = false;
    largeTapped = false;
    notifyListeners();
  }

  addToCart(BuildContext context, dynamic data) async {
    if (smallTapped != false || mediumTapped != false || largeTapped != false) {
      cartData++;
      await Provider.of<ManageData>(context,listen:false).submitData(context, data);
      notifyListeners();
    }else{
      return showModalBottomSheet(context: context, builder: (context){
        return Container(
          color: Colors.black,
          height: 50,
          child: Center(
            child: Text(
              "Select Size !",
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        );
      });
    }
  }
}
