import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shootingapp/login_page.dart';
import 'home_page.dart';


void main() => runApp(
  ChangeNotifierProvider<AuthService>(
    create: (context) => AuthService(),
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shooting competition login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        // get the Provider, and call the getUser method
        future: Provider.of<AuthService>(context).getUser(),
        // wait for the future to resolve and render the appropriate
        // widget for HomePage or LoginPage
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasData ? HomePage() : LoginPage();
          } else {
            return Container(color: Colors.white);
          }
        },
      ),
    );
  }
}

class AuthService with ChangeNotifier {
  var currentUser;

  AuthService() {
    print("new AuthService");
  }

  Future getUser() {
    return Future.value(currentUser);
  }

  // wrappinhg the firebase calls
  Future logout() {
    this.currentUser = null;
    notifyListeners();
    return Future.value(currentUser);
  }

  // wrapping the firebase calls
  Future createUser(
      {String firstName,
        String lastName,
        String user,
        String password}) async {}

  // logs in the user if password matches
  Future loginUser(String user, String password) {
    if (password == 'password123') {
      this.currentUser = {'user': user};
      notifyListeners();
      return Future.value(currentUser);
    } else {
      this.currentUser = null;
      return Future.value(null);
    }
  }
}



