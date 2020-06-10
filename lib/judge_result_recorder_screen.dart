import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shootingapp/authservice.dart';
import 'package:shootingapp/models/result.dart';
import 'package:shootingapp/models/user.dart';
import 'package:shootingapp/signout_header.dart';
import 'package:shootingapp/utilities/constants.dart';

class JudgeResultRecorderScreen extends StatefulWidget {
  JudgeResultRecorderScreen({this.currentUser, this.firestore});

  final FirebaseUser currentUser;
  final Firestore firestore;

  @override
  _JudgeResultRecorderScreenState createState() =>
      _JudgeResultRecorderScreenState(
          currentUser: currentUser, firestore: firestore);
}

class _JudgeResultRecorderScreenState extends State<JudgeResultRecorderScreen> {
  _JudgeResultRecorderScreenState({this.currentUser, this.firestore});

  final FirebaseUser currentUser;
  final Firestore firestore;

  String _fieldId;

  final _formKey = GlobalKey<FormState>();

  double _extraSmallWidthConst = 10.0;
  double _smallWidthConst = 30.0;
  double _mediumWidthConst = 40.0;
  double _largeWidthConst = 50.0;
  double _extraExtraSmallHeightConst = 5.0;
  double _extraSmallHeightConst = 10.0;
  double _smallHeightConst = 30.0;
  double _formPadding = 40.0;

  String _id;
  String _password;
  String _email;
  String _firstName;
  String _lastName;
  String _MDLSZ;
  int _serialNumber;
  String _category;
  String _division;
  String _currentRole;

  var _queryCat;
  var _mySelection;

  Widget _buildLastNameTF() {
    if (_mySelection != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: _extraSmallHeightConst,
            child: TextFormField(
              controller: _lastName != null
                  ? TextEditingController.fromValue(
                      TextEditingValue(text: _lastName))
                  : null,
              onSaved: (value) => _lastName = value,
              onChanged: (value) => _lastName = value,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildFirstNameTF() {
    if (_mySelection != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: _extraSmallHeightConst,
            child: TextFormField(
              controller: _firstName != null
                  ? TextEditingController.fromValue(
                      TextEditingValue(text: _firstName))
                  : null,
              onSaved: (value) => _firstName = value,
              onChanged: (value) => _firstName = value,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _buildMDLSZTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _extraSmallHeightConst,
          child: TextFormField(
            controller: _MDLSZ != null
                ? TextEditingController.fromValue(
                    TextEditingValue(text: _MDLSZ))
                : null,
            onSaved: (value) => _MDLSZ = value,
            onChanged: (value) => _MDLSZ = value,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.fingerprint,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSerialNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _extraSmallHeightConst,
          child: TextFormField(
            controller: _serialNumber != null
                ? TextEditingController.fromValue(
                    TextEditingValue(text: _serialNumber.toString()))
                : null,
            onSaved: (value) => _serialNumber = num.tryParse(value),
            onChanged: (value) => _serialNumber = num.tryParse(value),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.confirmation_number,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _extraSmallHeightConst,
          child: TextFormField(
            controller: _category != null
                ? TextEditingController.fromValue(
                    TextEditingValue(text: _category))
                : null,
            onSaved: (value) => _category = value,
            onChanged: (value) => _category = value,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.category,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivisionTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _extraSmallHeightConst,
          child: TextFormField(
            controller: _division != null
                ? TextEditingController.fromValue(
                    TextEditingValue(text: _division))
                : null,
            onSaved: (value) => _division = value,
            onChanged: (value) => _division = value,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.group,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserModificationSaveBtn() {
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
                await sendResultField(firestore: firestore, result: Result());
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            JudgeResultRecorderScreen(firestore: firestore)));
              } on AuthException catch (error) {
                return _buildErrorDialog(context, error.message);
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
            'BEADÁS',
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
    return Container();
  }

  Widget _buildConditionalFields() {
    if (_mySelection != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: _extraExtraSmallHeightConst,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(fit: FlexFit.loose, child: _buildMDLSZTF()),
                SizedBox(
                  width: _smallWidthConst,
                ),
                Flexible(fit: FlexFit.loose, child: _buildSerialNumberTF()),
              ],
            ),
          ),
          SizedBox(
            height: _extraExtraSmallHeightConst,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(fit: FlexFit.loose, child: _buildCategoryTF()),
                SizedBox(
                  width: _smallWidthConst,
                ),
                Flexible(fit: FlexFit.loose, child: _buildDivisionTF()),
              ],
            ),
          ),
        ],
      );
    } else {
      _MDLSZ = null;
      _serialNumber = null;
      _category = null;
      _division = null;
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    _extraSmallWidthConst = MediaQuery.of(context).size.width * 0.03;
    _smallWidthConst = MediaQuery.of(context).size.width * 0.08;
    _mediumWidthConst = MediaQuery.of(context).size.width * 0.2;
    _largeWidthConst = MediaQuery.of(context).size.width * 0.3;
    _extraExtraSmallHeightConst = MediaQuery.of(context).size.width * 0.015;
    _extraSmallHeightConst = MediaQuery.of(context).size.height * 0.03;
    _smallHeightConst = MediaQuery.of(context).size.height * 0.07;
    _formPadding = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _getFieldId(firestore),
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
                          _buildUserList(firestore),
                          SizedBox(
                            height: _extraSmallHeightConst,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildLastNameTF()),
                                SizedBox(
                                  width: _smallWidthConst,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildFirstNameTF()),
                              ],
                            ),
                          ),
                          _buildConditionalFields(),
                          _buildHorizontalLine(),
                          _buildUserModificationSaveBtn(),
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

  Widget _buildHorizontalLine() {
    if (_mySelection != null) {
      return Flexible(
        child: Column(
          children: <Widget>[
            Divider(
              color: Colors.white,
              thickness: 2,
            )
          ],
        ),
      );
    }
    return Container();
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
          title: Text('Információ'),
          content: Text("Biztosan elküldöd a kitöltött pontozólapot?"),
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
    ).then((exit) {
      if (exit == null) return;
      return exit;
    });
  }

  Widget _getFieldId(Firestore firestore) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('battlefields').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('');
          _queryCat = snapshot.data.documents;
          for (DocumentSnapshot document in _queryCat) {
            var _judgeIds = document.data['judgeIds'] == null
                ? []
                : document.data['judgeIds'];

            for (String judge in _judgeIds) {
              if (judge == currentUser.uid) {
                _fieldId = document.data['id'];
              }
            }
          }
          if (_fieldId == null) {
            return Text(
              'Pontozólap',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return Text(
            ['Pontozólap - ', _fieldId].join(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }

  Widget _buildUserList(Firestore firestore) {
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
                        .collection('users')
                        .where('userRole', isEqualTo: 'VERSENYZŐ')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');
                      var length = snapshot.data.documents.length;
                      DocumentSnapshot ds = snapshot.data.documents[length - 1];
                      _queryCat = snapshot.data.documents;
                      return Flexible(
                          fit: FlexFit.loose,
                          child: DropdownButton(
                            disabledHint: Text(
                              'Nincs hozzárendelt pálya',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontFamily: 'OpenSans',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            underline: Container(),
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconEnabledColor: Color(0xFF527DAA),
                            iconDisabledColor: Colors.white,
                            elevation: 5,
                            hint: Text('Válassz versenyzőt',
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
                            items: _fieldId == null
                                ? null
                                : snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                    return new DropdownMenuItem<String>(
                                        value: document.data['id'],
                                        child: Center(
                                            child: Text(
                                                [
                                                  document.data['lastName'],
                                                  " ",
                                                  document.data['firstName'],
                                                  " - ",
                                                  document.data['MDLSZ'],
                                                  " - ",
                                                  document.data['serialNumber']
                                                ].join(),
                                                style: TextStyle(
                                                  color: Color(0xFF527DAA),
                                                  letterSpacing: 1.5,
                                                  fontSize: 14.0,
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

  void changedDropDownItem(var selectedField) {
    print("Selected role $selectedField, we are going to refresh the UI");
    setState(() {
      for (DocumentSnapshot document in _queryCat) {
        if (document.data['id'] == selectedField) {
          _id = document.data['id'];
          _email = document.data['email'];
          _password = document.data['password'];
          _firstName = document.data['firstName'];
          _lastName = document.data['lastName'];
          _MDLSZ = document.data['MDLSZ'];
          _serialNumber = document.data['serialNumber'];
          _category = document.data['category'];
          _division = document.data['division'];
          ;
          _currentRole = document.data['userRole'];
        }
      }
      _mySelection = selectedField;
    });
  }

  Future sendResultField({Firestore firestore, Result result}) async {
    try {
      await firestore
          .collection("users")
          .document(result.id)
          .setData(result.toJson());
    } catch (e) {
      return e.message;
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
