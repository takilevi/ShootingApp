import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:shootingapp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollectionReference = Firestore.instance.collection("users");

  User _currentUser;
  User get currentUser => _currentUser;

  List<User> _allUsers = new List<User>();
  List<User> get allUsers => _allUsers;

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await getCurrentUser(user.uid);
    }
  }

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  // wrapping the firebase calls
  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
    return result;
  }

  // wrapping the firebase calls
  Future createUser(
      {String firstName,
        String lastName,
        String user,
        String password,
        String userRole,
        String MDLSZ,
        int serialNumber,
        String category,
        String division}) async {
    var email = user + '@shootingapp.com';

    allUsers.forEach((element) {
      if(element.serialNumber == serialNumber){
        throw Exception("Serial number is already in use, increase it!");
      }
    });
    allUsers.forEach((element) {
      if(element.MDLSZ == MDLSZ){
        throw Exception("MDLSZ number is already in the system.");
      }
    });

    var r = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    var u = r.user;
    UserUpdateInfo info = UserUpdateInfo();
    info.displayName = '$firstName $lastName';

    await createFirestoreUser(User(
        id: r.user.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        userRole: userRole,
        MDLSZ: MDLSZ,
        serialNumber: serialNumber,
        category: category,
        division: division));

    return await u.updateProfile(info);
  }

  Future createFirestoreUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  ///
  /// wrapping the firebase call to signInWithEmailAndPassword
  /// `email` String
  /// `password` String
  ///
  Future<FirebaseUser> loginUser({String user, String password}) async {
    try {
      var email = user + '@shootingapp.com';
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //_allUsers = await getAllUsers();
      _currentUser = await _populateCurrentUser(result.user);


      notifyListeners();
      return result.user;
    }  catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }

  Future getCurrentUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      return e.message;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      List<User> users;
      QuerySnapshot querySnapshot = await _usersCollectionReference.getDocuments();
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
