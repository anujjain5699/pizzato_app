import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  dynamic errorMessage = '';
  dynamic get getErrorMessage => errorMessage;

  String uid, userEmail;
  String get getUid => uid;
  String get getEmail => userEmail;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginIntoAccount(String email, String password) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      uid = user.uid;
      userEmail = user.email;

      sharedPreferences.setString('uid', uid);
      sharedPreferences.setString('useremail', userEmail);

      print(">>> *** This is Uid=>$getUid");
      notifyListeners();
    } catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'User Not Found';
          print("~~~~errorMessage: $errorMessage");
          break;
        case 'wrong-password':
          errorMessage = 'Oops, wrong password';
          print("~~~~errorMessage: $errorMessage");
          break;
        case 'invalid-email':
          errorMessage = 'Sorry invalid Email';
          print("~~~~errorMessage: $errorMessage");
          break;
      }
    }
  }

  Future createNewAccount(String email, String password) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      uid = user.uid;

      sharedPreferences.setString('uid', uid);

      print(">>> *** This is Uid=>$getUid");
      notifyListeners();
    } catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'Email already in use';
          print(errorMessage);
          break;
        case 'invalid-email':
          errorMessage = 'Sorry invalid Email';
          print("~~~~errorMessage: $errorMessage");
          break;
      }
    }
  }
}
