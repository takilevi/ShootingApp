import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:shootingapp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService with ChangeNotifier {
  Firestore db = Firestore.instance;

  User _currentUser;
  User get currentUser => _currentUser;


  List<User> _allUsers = new List<User>();
  List<User> get allUsers => _allUsers;



  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await getCurrentUser(user.uid);
    }
  }


  Future getCurrentUser(String uid) async {
    try {
      var userData = await db.collection("users").document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      return e.message;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      List<User> users;
      QuerySnapshot querySnapshot = await db.collection("users").getDocuments();
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        var a = querySnapshot.documents[i];
        var user = User.fromData(a.data);
        users.add(user);
      }
      return users;
    } catch (e) {
      return e.message;
    }
  }
}
