import 'package:flutter/material.dart';
import 'package:snowscape_tracker/data/recorded_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snowscape_tracker/utils/snack_bar.dart';
import 'package:snowscape_tracker/utils/user_preferences.dart';

class RecordActivityService {
  // Future<List<RecordedActivity>> getRecordedActivities() async {}

  Future<bool> saveRecordedActivity(RecordedActivity recordedActivity) async {
    String uid = UserPreferences.getUserUid();

    if (uid.isEmpty) {
      SnackBarWidget.show('User not logged in');
      return false;
    }

    final docRef = FirebaseFirestore.instance
        .collection('user_data')
        .doc(uid)
        .collection("recorded_activities")
        .doc();

    try {
      await docRef.set(recordedActivity.toMap());
    } catch (e) {
      debugPrint(e.toString());
      SnackBarWidget.show(e.toString());
      return false;
    }
    return true;
  }

  Stream<List<RecordedActivity>>? readRecordedSessions() {
    String uid = UserPreferences.getUserUid();

    if (uid.isEmpty) {
      // SnackBarWidget.show('User not logged in');
      return null;
    }

    return FirebaseFirestore.instance
        .collection("user_data")
        .doc(uid)
        .collection("recorded_activities")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecordedActivity.fromSnapshot(doc))
            .toList());
  }
}
