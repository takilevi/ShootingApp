import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shootingapp/admin_home_screen.dart';
import 'package:shootingapp/fancy_login_screen.dart';
import 'package:shootingapp/signup_screen.dart';
import 'authservice.dart';
import 'package:shootingapp/judge_result_recorder_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = FirebaseApp.instance;
  final Firestore firestore = Firestore(app: app);

  /*
  var credential = Credentials.applicationDefault();

  // when no credentials found, login using openid
  // the credentials are stored on disk for later use
  credential ??= await Credentials.login();

  // create an app
  var adminApp = FirebaseAdmin.instance.initializeApp(AppOptions(
      credential: credential ?? Credentials.applicationDefault(),
      projectId: 'shootingapp'));

  try {
    // get a user by email
    var v = await adminApp.auth().getUserByEmail('takacsl@shootingapp.com');
    print(v.toJson());
  } on FirebaseException catch (e) {
    print(e.message);
  }
  */

  runApp(ChangeNotifierProvider<AuthService>(
      create: (context) => AuthService(),
      child: MyApp(
        firestore: firestore,
      )));
}

class MyApp extends StatelessWidget {
  MyApp({this.firestore});

  final Firestore firestore;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shooting competition app',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            }
            // redirect to the proper page
            if (snapshot.hasData) {
              if (snapshot.data.photoUrl == "ADMIN") {
                return AdminHomeScreen(currentUser: snapshot.data, firestore: firestore);
              } else if (snapshot.data.photoUrl == "BÍRÓ"){
                return JudgeResultRecorderScreen(currentUser: snapshot.data, firestore: firestore);
              } else {
                return SignUpScreen();
              }
            }
            return FancyLoginScreen();
          } else {
            // show loading indicator
            return LoadingCircle();
          }
        },
      ),
    );
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}
