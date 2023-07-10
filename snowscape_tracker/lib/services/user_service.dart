import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class UserService {
  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          // we store user uid in shared preferences
          UserPreferences.setUserUid(value.user?.uid);
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        SnackBarWidget.show('No user found for that email.', null);
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        SnackBarWidget.show('Wrong password provided for that user.', null);
      } else {
        SnackBarWidget.show(e.code, null);
      }

      return false;
    }

    return true;
  }

  Future<bool> signup(String email, String password, String displayName) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          // we store user uid in shared preferences and name to firebase
          if (value.user != null) {
            UserPreferences.setUserUid(value.user?.uid);
            value.user?.updateDisplayName(displayName);
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        SnackBarWidget.show('The password provided is too weak.', null);
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        SnackBarWidget.show('The account already exists for that email.', null);
      } else {
        // print(e);
        SnackBarWidget.show(e.code, null);
      }

      return false;
    } catch (e) {
      debugPrint(e.toString());

      return false;
    }

    return true;
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      SnackBarWidget.show(e.toString(), null);
      debugPrint(e.toString());

      return false;
    }
    return true;
  }
}
