import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shootingapp/authservice.dart';
import 'package:shootingapp/battlefield_creator_screen.dart';
import 'package:shootingapp/models/battlefield.dart';
import 'package:shootingapp/utilities/constants.dart';
import 'package:shootingapp/utilities/weapon_aim2_icons.dart';
import 'package:shootingapp/utilities/weapon_aim_icons.dart';

class BattlefieldManagerScreen extends StatefulWidget {
  BattlefieldManagerScreen({this.firestore});

  final Firestore firestore;

  @override
  _BattlefieldManagerScreenState createState() =>
      _BattlefieldManagerScreenState(firestore: firestore);
}

class _BattlefieldManagerScreenState extends State<BattlefieldManagerScreen> {
  _BattlefieldManagerScreenState({this.firestore});

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

  var _mySelection;
  var _queryCat;

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
                        children: <Widget>[
                          buildFieldList(firestore),
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
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildModifyFieldBtn()),
                                SizedBox(
                                  width: _smallWidthConst,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildDeleteFieldBtn()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BattlefieldCreatorScreen(firestore: firestore)),);
        },
        label: Text(
          'Új pálya',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        icon: Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF527DAA),
      ),
    );
  }

  Widget buildFieldList(Firestore firestore) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10, bottom: 10),
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('battlefields')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');
                      var length = snapshot.data.documents.length;
                      DocumentSnapshot ds = snapshot.data.documents[length - 1];
                      _queryCat = snapshot.data.documents;
                      return Flexible(
                          fit: FlexFit.loose,
                          child: DropdownButton(
                            underline: Container(),
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconEnabledColor: Color(0xFF527DAA),
                            iconDisabledColor: Colors.white,
                            elevation: 5,
                            hint: Text('Válassz pályát',
                                style: TextStyle(
                                  color: Color(0xFF527DAA),
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                )),
                            value: _mySelection,
                            isDense: true,
                            onChanged: changedDropDownItem,
                            items: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return new DropdownMenuItem<String>(
                                  value: document.data['id'],
                                  child: Center(
                                      child: Text(
                                          [
                                            document.data['id'],
                                            " - ",
                                            document.data['competitionType']
                                          ].join(),
                                          style: TextStyle(
                                            color: Color(0xFF527DAA),
                                            letterSpacing: 1.5,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          ))));
                            }).toList(),
                            style: TextStyle(
                              color: Color(0xFF527DAA),
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ));
                    }))),
      ],
    );
  }

  Widget _buildDescriptionTF() {
    if (_mySelection != null) {
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
              controller: _description != null
                  ? TextEditingController.fromValue(
                      TextEditingValue(text: _description))
                  : null,
              onSaved: (value) => _description = value,
              onChanged: (value) => _description = value,
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
    return Container();
  }

  Widget _buildCompetitionTypeTF() {
    if (_mySelection != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: _smallHeightConst,
            child: TextFormField(
              keyboardType: TextInputType.text,
              maxLines: null,
              controller: _competitionType != null
                  ? TextEditingController.fromValue(
                      TextEditingValue(text: _competitionType))
                  : null,
              onSaved: (value) => _competitionType = value,
              onChanged: (value) => _competitionType = value,
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
    return Container();
  }

  Widget _buildPenaltyVetlenCB() {
    if (_mySelection != null) {
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
    return Container();
  }

  Widget _buildPenaltyEljarasiCB() {
    if (_mySelection != null) {
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
    return Container();
  }

  Widget _buildPenaltyMNTCB() {
    if (_mySelection != null) {
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
    return Container();
  }

  Widget _buildPenaltyAlakCB() {
    if (_mySelection != null) {
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
    return Container();
  }

  Widget _buildPenaltyEgyebCB() {
    if (_mySelection != null) {
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
    return Container();
  }

  Widget _buildPenaltyJokerCB() {
    if (_mySelection != null) {
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
                        if(buttonIndex==0){_penaltyJokerNyilt=jokerPenalty[buttonIndex];}
                        if(buttonIndex==1){_penaltyJokerOptikai=jokerPenalty[buttonIndex];}
                      }
                    });
                  },
                  isSelected: jokerPenalty,
                ),
              ),
            ],
          ));
    }
    return Container();
  }

  Widget _buildModifyFieldBtn() {
    if (_mySelection != null) {
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
                await modifyField(firestore:firestore, battlefield: Battlefield(
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

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BattlefieldManagerScreen(firestore: firestore)));

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
            'MÓDOSÍTÁS',
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
    return Container();
  }

  Widget _buildDeleteFieldBtn() {
    if (_mySelection != null) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            // save the fields..
            final form = _formKey.currentState;
            form.save();
            bool shouldContinue = await _buildWarningDialog(context);
            if(!shouldContinue){
              return;
            }
            // Validate will return true if is valid, or false if invalid.
            if (form.validate()) {
              try {
                await deleteField(firestore:firestore, battlefield: Battlefield(
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
            'TÖRLÉS',
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
    return Container();
  }

  Future modifyField({Firestore firestore, Battlefield battlefield}) async {
    try {
      await firestore
          .collection("battlefields")
          .document(battlefield.id)
          .setData(battlefield.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future deleteField({Firestore firestore, Battlefield battlefield}) async {
    try {
      await firestore.collection('battlefields').document(battlefield.id).delete();
    } catch (e) {
      return e.message;
    }
  }

  void changedDropDownItem(var selectedField) {
    print("Selected role $selectedField, we are going to refresh the UI");
    setState(() {
      for (DocumentSnapshot document in _queryCat) {
        if (document.data['id'] == selectedField) {
          print(document.data['id']);
          _id = document.data['id'];
          _description = document.data['description'] == null ? "" : document.data['description'];
          _competitionType = document.data['competitionType'];
          _penaltyVetlen = document.data['penaltyVetlen'] == null ? false : document.data['penaltyVetlen'];
          _penaltyEljarasi = document.data['penaltyEljarasi'] == null ? false : document.data['penaltyEljarasi'];
          _penaltyMNT = document.data['penaltyMNT'] == null ? false : document.data['penaltyMNT'];
          _penaltyAlak = document.data['penaltyAlak'] == null ? false : document.data['penaltyAlak'];
          _penaltyJokerNyilt= document.data['penaltyJokerNyilt'] == null ? false : document.data['penaltyJokerNyilt'];
          _penaltyJokerOptikai = document.data['penaltyJokerOptikai'] == null ? false : document.data['penaltyJokerOptikai'];
          _penaltyEgyeb = document.data['penaltyEgyeb'] == null ? false : document.data['penaltyEgyeb'];
          jokerPenalty[0]=_penaltyJokerNyilt;
          jokerPenalty[1]=_penaltyJokerOptikai;
        }
      }
      _mySelection = selectedField;
    });
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

  Future _buildWarningDialog(BuildContext context) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Figyelmeztetés'),
          content: Text("Biztosan ki akarod törölni ezt a pályát?"),
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
