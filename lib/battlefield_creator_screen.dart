import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BattlefieldCreatorScreen extends StatefulWidget {
  BattlefieldCreatorScreen({this.firestore});

  final Firestore firestore;

  @override
  _BattlefieldCreatorScreenState createState() =>
      _BattlefieldCreatorScreenState(firestore: firestore);
}

class _BattlefieldCreatorScreenState extends State<BattlefieldCreatorScreen> {
  _BattlefieldCreatorScreenState({this.firestore});

  final Firestore firestore;
  final _formKey = GlobalKey<FormState>();
  double _extraSmallWidthConst = 10.0;
  double _smallWidthConst = 30.0;
  double _mediumWidthConst = 40.0;
  double _largeWidthConst = 50.0;
  double _extraSmallHeightConst = 10.0;
  double _smallHeightConst = 30.0;
  double _formPadding = 40.0;

  String id;
  String description;
  List<String> judgeIds;
  String competitionType;
  bool penaltyVetlen;
  bool penaltyEljarasi;
  bool penaltyMNT;
  bool penaltyAlak;
  bool penaltyJokerNyilt;
  bool penaltyJokerOptikai;
  bool penaltyEgyeb;

  @override
  Widget build(BuildContext context) {
    _extraSmallWidthConst = MediaQuery
        .of(context)
        .size
        .width * 0.03;
    _smallWidthConst = MediaQuery
        .of(context)
        .size
        .width * 0.08;
    _mediumWidthConst = MediaQuery
        .of(context)
        .size
        .width * 0.2;
    _largeWidthConst = MediaQuery
        .of(context)
        .size
        .width * 0.3;
    _extraSmallHeightConst = MediaQuery
        .of(context)
        .size
        .height * 0.03;
    _smallHeightConst = MediaQuery
        .of(context)
        .size
        .height * 0.07;
    _formPadding = MediaQuery
        .of(context)
        .size
        .height * 0.05;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pályák menedzselése',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF73AEF5),
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
              Form(
                  key: _formKey,
                  child: Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: _extraSmallWidthConst,
                        vertical: _formPadding,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[

                                SizedBox(
                                  width: _smallWidthConst,
                                ),

                              ],
                            ),
                          ),
                          SizedBox(
                            height: _extraSmallHeightConst,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[

                                SizedBox(
                                  width: _smallWidthConst,
                                ),

                              ],
                            ),
                          ),
                          SizedBox(
                            height: _smallHeightConst,
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('Új pálya',
          style: TextStyle(
            fontSize: 18.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      ),
      icon: Icon(Icons.add),
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF527DAA),
    ),);
  }
}
