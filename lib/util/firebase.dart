import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser.uid.toString();

Future<Void> userSetup(String displayName, String email, String password,
    String userType, String deviceType,  String photo) async {
  /*CollectionReference users =*/
  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .set({
    // .where('id', isEqualTo: uid);
    // FirebaseAuth auth = FirebaseAuth.instance;
    // String uid = auth.currentUser.uid.toString();
    // users.add({
    'displayName': displayName,
    'email': email,
    'fullName': displayName,
    'uid': uid,
    'password': password,
    'userType': userType,
    'deviceType': deviceType,
    'gender': '',
    'weight': '',
    'height': '',
    'age_group': '',
    'photo': photo,
    // });
  });
}

Future<Void> updateUserDetails(
    {String uid,
    String gender,
    String weight,
    String height,
    String age_group}) async {
  // CollectionReference users =
  FirebaseFirestore.instance.collection('users').doc(uid).update({
    // FirebaseAuth auth = FirebaseAuth.instance;
    // String uid = auth.currentUser.uid.toString();
    // users.add({
    'uid': uid,
    'gender': gender,
    'weight': weight,
    'height': height,
    'age_group': age_group,
    // });
  });
}

Future<Void> feedbackSetup(String uid, String displayName, String email,
    String comment, String deviceType) async {
  CollectionReference feedback =
      FirebaseFirestore.instance.collection('feedback');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  feedback.add({
    'uid': uid,
    'displayName': displayName,
    'email': email,
    'comment': comment,
    'deviceType': deviceType,
  });
  // return;
}
