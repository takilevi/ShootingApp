import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shootingapp/authservice.dart';
import 'package:shootingapp/signout_header.dart';

class AdminHomeScreen extends StatefulWidget {
  AdminHomeScreen({this.currentUser,this.firestore});
  final FirebaseUser currentUser;
  final Firestore firestore;

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState(firestore: firestore);
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  _AdminHomeScreenState({this.firestore});
  final Firestore firestore;
  double _extraSmallWidthConst = 10.0;
  double _smallWidthConst = 30.0;
  double _extraSmallHeightConst = 10.0;
  double _smallHeightConst = 30.0;


  @override
  Widget build(BuildContext context) {
    _extraSmallWidthConst = MediaQuery.of(context).size.width * 0.03;
    _smallWidthConst=  MediaQuery.of(context).size.width * 0.08;
    _extraSmallHeightConst = MediaQuery.of(context).size.height * 0.03;
    _smallHeightConst = MediaQuery.of(context).size.height * 0.07;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Szervező főoldal',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF73AEF5),
        leading: Transform.rotate(
          angle: 180 * pi / 180,
          child: IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: MediaQuery.of(context).size.height * 0.048,
            color: Colors.white,
            tooltip: 'Kijelentkezés',
            autofocus: true,
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: kReleaseMode)
                  .logout();
            },
          ),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: _extraSmallWidthConst,
                    vertical: _extraSmallHeightConst,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //Pályák létrehozása
                      _buildBattlefieldBtn(),
                      //Versenyzők, bírók felvétele
                      _buildSignupBtn(),
                      //Bíró-pálya összerendelés
                      _buildJudgeToFieldBtn(),
                      //Előző verseny maradványainak kitakarítása - userek, pályák törlése
                      _buildSwipeAllDataBtn(firestore),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBattlefieldBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BattlefieldCreatorScreen()),
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Új pálya létrehozása',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildJudgeToFieldBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BattlefieldCreatorScreen()),
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Új pálya létrehozása',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  Widget _buildSignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BattlefieldCreatorScreen()),
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Új pálya létrehozása',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeAllDataBtn(Firestore firestore) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          bool shouldContinue = await _buildWarningDialog(context);
          if(!shouldContinue){
            return;
          }
          await firestore.collection('users').getDocuments().then((snapshot) {
            for (DocumentSnapshot ds in snapshot.documents) {
              if(ds.data['email']!='takacsl@shootingapp.com'){
                Provider.of<AuthService>(context, listen: kReleaseMode).deleteUser(email: ds.data['email'], password: ds.data['password']);
                ds.reference.delete();
              }
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Minden adat törlése',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Future _buildWarningDialog(BuildContext context) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Figyelmeztetés'),
          content: Text("Biztosan ki akarsz törölni MINDEN rekordod az adatbázisból?"),
          actions: <Widget>[
            FlatButton(
                child: Text('Vissza'),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
            FlatButton(
                child: Text('Igen'),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
          ],
        );
      },
      context: context,
    ).then((exit){
      if (exit == null) return;
      return exit;
    });
  }
}

class BattlefieldCreatorScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Új pálya létrehozása"),
        backgroundColor: Color(0xFF73AEF5),
      ),
      body: Center(
      ),
    );
  }
}


