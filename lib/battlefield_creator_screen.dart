import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shootingapp/authservice.dart';
import 'package:shootingapp/utilities/constants.dart';

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
                        //mainAxisAlignment: MainAxisAlignment.center,
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
        onPressed: () {
          // Add your onPressed code here!
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
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _competitionType != null
                  ? TextEditingController.fromValue(
                      TextEditingValue(text: _competitionType))
                  : null,
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
              top: _checkBoxPadding),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Nyílt',
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _checkBoxPadding,
                    ),
                    Expanded(
                        child: Text(
                      'Optikai',
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          value: _penaltyJokerNyilt,
                          onChanged: (bool value) {
                            setState(() {
                              _penaltyJokerNyilt = value;
                            });
                          },
                          activeColor: Color(0xFF398AE5),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _checkBoxPadding,
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          value: _penaltyJokerOptikai,
                          onChanged: (bool value) {
                            setState(() {
                              _penaltyJokerOptikai = value;
                            });
                          },
                          activeColor: Color(0xFF398AE5),
                        ),
                      ),
                    ),
                  ],
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
                await modifyField(firestore);
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

            // Validate will return true if is valid, or false if invalid.
            if (form.validate()) {
              try {
                await deleteField(firestore);
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

  Future modifyField(Firestore firestore) {}

  Future deleteField(Firestore firestore) {}

  void changedDropDownItem(var selectedField) {
    print("Selected role $selectedField, we are going to refresh the UI");
    setState(() {
      for (DocumentSnapshot document in _queryCat) {
        if (document.data['id'] == selectedField) {
          print(document.data['id']);
          _id = document.data['id'];
          _description = document.data['description'];
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
}
