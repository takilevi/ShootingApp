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

class JudgeToFieldScreen extends StatefulWidget {
  JudgeToFieldScreen({this.firestore});

  final Firestore firestore;

  @override
  _JudgeToFieldScreenState createState() =>
      _JudgeToFieldScreenState(firestore: firestore);
}

class _JudgeToFieldScreenState extends State<JudgeToFieldScreen> {
  _JudgeToFieldScreenState({this.firestore});

  final Firestore firestore;
  final _formKey = GlobalKey<FormState>();
  double _extraSmallWidthConst = 10.0;
  double _smallWidthConst = 30.0;
  double _extraSmallHeightConst = 10.0;
  double _smallHeightConst = 30.0;
  double _largeHeightConst = 50.0;
  double _formPadding = 40.0;
  double _checkBoxPadding = 5.0;
  var jokerPenalty = [false, false];

  var _mySelection;
  var _queryCat;

  Map<String,bool> _judgeList = new Map();

  String _id;
  String _description;
  List<dynamic> _judgeIds;
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
    _extraSmallHeightConst = MediaQuery.of(context).size.height * 0.03;
    _smallHeightConst = MediaQuery.of(context).size.height * 0.07;
    _largeHeightConst = MediaQuery.of(context).size.height * 0.5;
    _formPadding = MediaQuery.of(context).size.height * 0.05;
    _checkBoxPadding = MediaQuery.of(context).size.height * 0.007;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Bíró-pálya összerendelés',
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
                          _buildFieldList(firestore),
                          SizedBox(
                            height: _extraSmallHeightConst,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(flex: 3, child: _buildIdAndTypeTF()),
                              SizedBox(
                                width: _smallWidthConst,
                              ),
                              Expanded(flex: 5, child: _buildJudgeList())
                            ],
                          ),
                          SizedBox(
                            height: _smallHeightConst,
                          ),
                          _buildSaveFieldBtn()
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

  Widget _buildFieldList(Firestore firestore) {
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

  Widget _buildIdAndTypeTF() {
    if (_mySelection != null) {
      return Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle,
                height: _smallHeightConst,
                child: TextFormField(
                  readOnly: true,
                  controller: _id != null
                      ? TextEditingController.fromValue(
                      TextEditingValue(text: _id))
                      : null,
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
              SizedBox(
                height: _smallHeightConst,
              ),
              Container(
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle,
                height: _smallHeightConst,
                child: TextFormField(
                  readOnly: true,
                  controller: _competitionType != null
                      ? TextEditingController.fromValue(
                      TextEditingValue(text: _competitionType))
                      : null,
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
              )
            ],
          ));
    }
    return Container();
  }

  Widget _buildJudgeList() {
    if (_mySelection != null) {
      return Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _largeHeightConst,
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("users")
                .where('userRole', isEqualTo: 'BÍRÓ')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              final int messageCount = snapshot.data.documents.length;
              return ListView.separated(
                itemCount: messageCount,
                itemBuilder: (_, int index) {
                  final DocumentSnapshot document =
                  snapshot.data.documents[index];
                  final dynamic firstName = document['firstName'];
                  final dynamic lastName = document['lastName'];
                  final dynamic judgeId = document['id'];
                  return ListTile(
                    trailing: Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: Checkbox(
                        value: _judgeList[judgeId] == null ? false : _judgeList[judgeId],
                        onChanged: (bool value) {
                          setState(() {
                            if(value) _judgeList[judgeId] = value;
                            if(!value) _judgeList.remove(judgeId);
                          });
                        },
                        activeColor: Color(0xFF398AE5),
                      ),
                    ),
                    title: Text(
                      [lastName, " ", firstName].join(),
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(
                  color:Colors.white
                ),
              );
            },
          ));
    }
    return Container();
  }

  Widget _buildSaveFieldBtn() {
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
                await modifyField(
                    firestore: firestore,
                    battlefield: Battlefield(
                        id: _id,
                        description: _description,
                        competitionType: _competitionType,
                        judgeIds: _judgeList.keys.toList(),
                        penaltyAlak: _penaltyAlak,
                        penaltyEgyeb: _penaltyEgyeb,
                        penaltyEljarasi: _penaltyEljarasi,
                        penaltyVetlen: _penaltyVetlen,
                        penaltyMNT: _penaltyMNT,
                        penaltyJokerNyilt: _penaltyJokerNyilt,
                        penaltyJokerOptikai: _penaltyJokerOptikai));

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            JudgeToFieldScreen(firestore: firestore)));
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

  void changedDropDownItem(var selectedField) {
    print("Selected role $selectedField, we are going to refresh the UI");
    setState(() {
      for (DocumentSnapshot document in _queryCat) {
        if (document.data['id'] == selectedField) {
          print(document.data['id']);
          _id = document.data['id'];
          _description = document.data['description'] == null
              ? ""
              : document.data['description'];
          _competitionType = document.data['competitionType'];
          _penaltyVetlen = document.data['penaltyVetlen'] == null
              ? false
              : document.data['penaltyVetlen'];
          _penaltyEljarasi = document.data['penaltyEljarasi'] == null
              ? false
              : document.data['penaltyEljarasi'];
          _penaltyMNT = document.data['penaltyMNT'] == null
              ? false
              : document.data['penaltyMNT'];
          _penaltyAlak = document.data['penaltyAlak'] == null
              ? false
              : document.data['penaltyAlak'];
          _penaltyJokerNyilt = document.data['penaltyJokerNyilt'] == null
              ? false
              : document.data['penaltyJokerNyilt'];
          _penaltyJokerOptikai = document.data['penaltyJokerOptikai'] == null
              ? false
              : document.data['penaltyJokerOptikai'];
          _penaltyEgyeb = document.data['penaltyEgyeb'] == null
              ? false
              : document.data['penaltyEgyeb'];
          jokerPenalty[0] = _penaltyJokerNyilt;
          jokerPenalty[1] = _penaltyJokerOptikai;
          _judgeIds = document.data['judgeIds'] == null
              ? []
              : document.data['judgeIds'];

          _judgeList = new Map();
          for(String judge in _judgeIds){
            _judgeList[judge] = true;
          }
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
