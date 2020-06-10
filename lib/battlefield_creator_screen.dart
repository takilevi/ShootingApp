import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shootingapp/authservice.dart';
import 'package:shootingapp/models/battlefield.dart';
import 'package:shootingapp/utilities/constants.dart';
import 'package:shootingapp/utilities/weapon_aim2_icons.dart';
import 'package:shootingapp/utilities/weapon_aim_icons.dart';

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
  double _checkBoxPadding = 5.0;
  var jokerPenalty = [false, false];

  String _id;
  String _description;
  List<String> _judgeIds;
  String _competitionType;
  bool _penaltyVetlen = false;
  bool _penaltyEljarasi = false;
  bool _penaltyMNT = false;
  bool _penaltyAlak = false;
  bool _penaltyJokerNyilt = false;
  bool _penaltyJokerOptikai = false;
  bool _penaltyEgyeb = false;

  @override
  Widget build(BuildContext context) {
    _extraSmallWidthConst = MediaQuery.of(context).size.width * 0.03;
    _smallWidthConst = MediaQuery.of(context).size.width * 0.08;
    _mediumWidthConst = MediaQuery.of(context).size.width * 0.2;
    _largeWidthConst = MediaQuery.of(context).size.width * 0.3;
    _extraSmallHeightConst = MediaQuery.of(context).size.height * 0.03;
    _smallHeightConst = MediaQuery.of(context).size.height * 0.07;
    _formPadding = MediaQuery.of(context).size.height * 0.05;
    _checkBoxPadding = MediaQuery.of(context).size.height * 0.007;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pálya létrehozása',
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
                          _buildIdTF(),
                          SizedBox(
                            height: _extraSmallHeightConst,
                          ),
                          _buildDescriptionTF(),
                          SizedBox(
                            height: _extraSmallHeightConst,
                          ),
                          _buildCompetitionTypeTF(),
                          SizedBox(
                            height: _extraSmallHeightConst,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildPenaltyVetlenCB()),
                                SizedBox(
                                  width: _smallWidthConst,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildPenaltyEljarasiCB()),
                                SizedBox(
                                  width: _smallWidthConst,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildPenaltyMNTCB()),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _smallHeightConst,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildPenaltyAlakCB()),
                                SizedBox(
                                  width: _smallWidthConst,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildPenaltyJokerCB()),
                                SizedBox(
                                  width: _smallWidthConst,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildPenaltyEgyebCB()),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _smallHeightConst,
                          ),
                          _buildAddFieldBtn()
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _smallHeightConst,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Kötelező azonosítót megadni';
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) => _id = value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.map, //explore, info, map
                color: Colors.white,
              ),
              labelText: 'Azonosító',
              labelStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _smallHeightConst,
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) => _description = value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.description,
                color: Colors.white,
              ),
              labelText: 'Leírás',
              labelStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompetitionTypeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _smallHeightConst,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Kötelező typust megadni';
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) => _competitionType = value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.adjust,
                color: Colors.white,
              ),
              labelText: 'Pályacél',
              labelStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPenaltyVetlenCB() {
    return Container(
        decoration: kBoxDecorationStyle,
        padding: EdgeInsets.only(
            left: _checkBoxPadding,
            right: _checkBoxPadding,
            top: _checkBoxPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Vétlen',
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: _checkBoxPadding,
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _penaltyVetlen,
                onChanged: (bool value) {
                  setState(() {
                    _penaltyVetlen = value;
                  });
                },
                activeColor: Color(0xFF398AE5),
              ),
            ),
          ],
        ));
  }

  Widget _buildPenaltyEljarasiCB() {
    return Container(
        decoration: kBoxDecorationStyle,
        padding: EdgeInsets.only(
            left: _checkBoxPadding,
            right: _checkBoxPadding,
            top: _checkBoxPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Eljárási',
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: _checkBoxPadding,
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _penaltyEljarasi,
                onChanged: (bool value) {
                  setState(() {
                    _penaltyEljarasi = value;
                  });
                },
                activeColor: Color(0xFF398AE5),
              ),
            ),
          ],
        ));
  }

  Widget _buildPenaltyMNTCB() {
    return Container(
        decoration: kBoxDecorationStyle,
        padding: EdgeInsets.only(
            left: _checkBoxPadding,
            right: _checkBoxPadding,
            top: _checkBoxPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'MNT',
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: _checkBoxPadding,
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _penaltyMNT,
                onChanged: (bool value) {
                  setState(() {
                    _penaltyMNT = value;
                  });
                },
                activeColor: Color(0xFF398AE5),
              ),
            ),
          ],
        ));
  }

  Widget _buildPenaltyAlakCB() {
    return Container(
        decoration: kBoxDecorationStyle,
        padding: EdgeInsets.only(
            left: _checkBoxPadding,
            right: _checkBoxPadding,
            top: _checkBoxPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Alak',
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: _checkBoxPadding,
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _penaltyAlak,
                onChanged: (bool value) {
                  setState(() {
                    _penaltyAlak = value;
                  });
                },
                activeColor: Color(0xFF398AE5),
              ),
            ),
          ],
        ));
  }

  Widget _buildPenaltyEgyebCB() {
    return Container(
        decoration: kBoxDecorationStyle,
        padding: EdgeInsets.only(
            left: _checkBoxPadding,
            right: _checkBoxPadding,
            top: _checkBoxPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Egyéb',
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: _checkBoxPadding,
            ),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _penaltyEgyeb,
                onChanged: (bool value) {
                  setState(() {
                    _penaltyEgyeb = value;
                  });
                },
                activeColor: Color(0xFF398AE5),
              ),
            ),
          ],
        ));
  }

  Widget _buildPenaltyJokerCB() {
    return Container(
        decoration: kBoxDecorationStyle,
        padding: EdgeInsets.only(
            left: _checkBoxPadding,
            right: _checkBoxPadding,
            top: _checkBoxPadding,
            bottom: _checkBoxPadding),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Joker',
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: _checkBoxPadding,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ToggleButtons(
                color: Color(0xFF398AE5),
                selectedColor: Colors.white,
                selectedBorderColor: Colors.white,
                borderColor: Color(0xFF6CA8F1),
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: Icon(WeaponAim2.iron_sigh_notarget),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Icon(WeaponAim.crosshairs),
                  )
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < jokerPenalty.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        jokerPenalty[buttonIndex] = !jokerPenalty[buttonIndex];
                      } else {
                        jokerPenalty[buttonIndex] = false;
                      }
                      if (buttonIndex == 0) {
                        _penaltyJokerNyilt = jokerPenalty[buttonIndex];
                      }
                      if (buttonIndex == 1) {
                        _penaltyJokerOptikai = jokerPenalty[buttonIndex];
                      }
                    }
                  });
                },
                isSelected: jokerPenalty,
              ),
            ),
          ],
        ));
  }

  Widget _buildAddFieldBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          // save the fields..
          final form = _formKey.currentState;
          form.save();

          // Validate will return true if is valid, or false if invalid.
          if (form.validate()) {
            try {
              await addField(
                  firestore: firestore,
                  battlefield: Battlefield(
                      id: _id,
                      description: _description,
                      competitionType: _competitionType,
                      judgeIds: [],
                      penaltyAlak: _penaltyAlak,
                      penaltyEgyeb: _penaltyEgyeb,
                      penaltyEljarasi: _penaltyEljarasi,
                      penaltyVetlen: _penaltyVetlen,
                      penaltyMNT: _penaltyMNT,
                      penaltyJokerNyilt: _penaltyJokerNyilt,
                      penaltyJokerOptikai: _penaltyJokerOptikai));
              Navigator.pop(context);
            } on Exception catch (error) {
              return _buildErrorDialog(context, error.toString());
            } catch (error) {
              return _buildErrorDialog(context, error.toString());
            }
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'MENTÉS',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.2,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Future addField({Firestore firestore, Battlefield battlefield}) async {

    final QuerySnapshot result =
    await firestore.collection('battlefields').where('id', isEqualTo:
    battlefield.id).getDocuments();

    final List < DocumentSnapshot > documents = result.documents;
    if (documents.length != 0) {
      throw Exception("Ilyen pálya már létezik, adj meg másik azonosítót!");
    }

    try {
      await firestore
          .collection("battlefields")
          .document(battlefield.id)
          .setData(battlefield.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }
}
