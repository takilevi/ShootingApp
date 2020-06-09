import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:shootingapp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollectionReference = Firestore.instance.collection("users");

  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  // wrapping the firebase calls
  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
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

    /*allUsers.forEach((element) {
      if(element.serialNumber == serialNumber){
        throw Exception("Serial number is already in use, increase it!");
      }
    });
    allUsers.forEach((element) {
      if(element.MDLSZ == MDLSZ){
        throw Exception("MDLSZ number is already in the system.");
      }
    });*/

    var r = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    var u = r.user;

    UserUpdateInfo info = UserUpdateInfo();
    info.displayName = '$firstName $lastName';
    info.photoUrl = userRole;

    await createFirestoreUser(User(
        id: r.user.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        userRole: userRole,
        MDLSZ: MDLSZ,
        serialNumber: serialNumber,
        category: category,
        division: division,
        password: password));

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

      notifyListeners();
      return result.user;
    }  catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }

  Future deleteUser({String email, String password}) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      AuthCredential credentials =
      EmailAuthProvider.getCredential(email: email, password: password);
      print(user);
      AuthResult result = await user.reauthenticateWithCredential(credentials);
      await result.user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteUserByAdmin({String email}) async{

  }
}

