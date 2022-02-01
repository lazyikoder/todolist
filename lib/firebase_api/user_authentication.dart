import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolistapp/cache_data/shared_preference_service.dart';
import 'package:todolistapp/firebase_api/database_method.dart';

class UserAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> userLoginWithEmailAndPassword(
      String userLoginEmail, String userLoginPassword) async {
    SharedPreferenceService _sharedPreferenceService =
        SharedPreferenceService();
    String userdocID = "";
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: userLoginEmail, password: userLoginPassword);
      User? user = userCredential.user;
      if (user != null) {
        userdocID = user.uid;
        Map<String, dynamic> usermap = {
          "username": user.displayName as String,
          "email": userLoginEmail,
          "password": userLoginPassword,
          "userDocId": user.uid,
        };

        await _sharedPreferenceService.saveUserData(usermap);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return userdocID;
  }

  Future<String> userSignUpWithEmailAndPassword(
      Map<String, dynamic> userSignUpInfo) async {
    String userdocID = "";

    try {
      SharedPreferenceService _sharedPreferenceService =
          SharedPreferenceService();
      DataBaseMethod dataBaseMethod = DataBaseMethod();
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: userSignUpInfo['email'],
              password: userSignUpInfo['password']);
      User? user = userCredential.user;
      if (user != null) {
        userdocID = user.uid;
        user.updateDisplayName(userSignUpInfo['name']);
        await dataBaseMethod.storeUserDataOnSignUp(userSignUpInfo, user.uid);

        await _sharedPreferenceService.saveUserData(
          {
            "username": userSignUpInfo['name'],
            "email": userSignUpInfo['email'],
            "password": userSignUpInfo['password'],
            "userDocId": user.uid,
          },
        );
        // print("User created successfully...");
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "Entered email already in use",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return userdocID;
  }

  Future<bool> userLogOut() async {
    bool isUserLogOut = false;
    try {
      SharedPreferenceService preferenceService = SharedPreferenceService();
      preferenceService.removeUserData();
      _firebaseAuth.signOut();
      isUserLogOut = true;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return isUserLogOut;
  }
}
