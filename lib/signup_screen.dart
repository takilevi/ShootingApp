import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shootingapp/authservice.dart';
import 'package:shootingapp/signout_header.dart';
import 'package:shootingapp/utilities/constants.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.currentUser});
  final FirebaseUser currentUser;
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  static final String COMPETITOR = "VERSENYZŐ";
  static final String JUDGE = "BÍRÓ";
  static final String ADMIN = "ADMIN";
  final _formKey = GlobalKey<FormState>();
  double _extraSmallWidthConst = 10.0;
  double _smallWidthConst = 30.0;
  double _mediumWidthConst = 40.0;
  double _largeWidthConst = 50.0;
  double _extraSmallHeightConst = 10.0;
  double _smallHeightConst = 30.0;
  double _formPadding = 40.0;


  String _password;
  String _username;
  String _firstName;
  String _lastName;
  String _MDLSZ;
  int _serialNumber;
  String _category;
  String _division;

  List<String> _userRoles =
  [COMPETITOR, JUDGE, ADMIN];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentRole;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentRole = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String role in _userRoles) {
      items.add(new DropdownMenuItem(
          value: role,
          child: new Text(role)
      ));
    }
    return items;
  }


  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _smallHeightConst,
          child: TextFormField(
            onSaved: (value) => _username = value,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.assignment_ind,
                color: Colors.white,
              ),
              labelText: 'Felhasználónév',
              labelStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _smallHeightConst,
          child: TextFormField(
            onSaved: (value) => _password = value,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              labelText: 'Jelszó',
              labelStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildLastNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _smallHeightConst,
          child: TextFormField(
            onSaved: (value) => _lastName = value,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              labelText: 'Vezetéknév',
              labelStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _smallHeightConst,
          child: TextFormField(
            onSaved: (value) => _firstName = value,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              labelText: 'Keresztnév',
              labelStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMDLSZTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: _smallHeightConst,
          child: TextFormField(
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            onSaved: (value) => _MDLSZ = value,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.fingerprint,
                color: Colors.white,
              ),
              labelText: 'MDLSZ azonosító',
              labelStyle: kHintTextStyle,
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
          height: _smallHeightConst,
          child: TextFormField(
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            onSaved: (value) => _serialNumber = num.tryParse(value),
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.confirmation_number,
                color: Colors.white,
              ),
              labelText: 'Sorszám',
              labelStyle: kHintTextStyle,
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
          height: _smallHeightConst,
          child: TextFormField(
            onSaved: (value) => _category = value,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.category,
                color: Colors.white,
              ),
              labelText: 'Kategória',
              labelStyle: kHintTextStyle,
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
          height: _smallHeightConst,
          child: TextFormField(
            onSaved: (value) => _division = value,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 2.0),
              prefixIcon: Icon(
                Icons.group,
                color: Colors.white,
              ),
              labelText: 'Divízió',
              labelStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropDown() {
    return IntrinsicHeight (
      child: Row(
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
                  padding: EdgeInsets.only(left:15.0,right:15.0),
                child:DropdownButton(
                  underline: Container(),
                  icon: Icon(Icons.arrow_drop_down_circle),
                  iconEnabledColor: Color(0xFF527DAA),
                  iconDisabledColor: Colors.white,
                  elevation: 5,
                  value: _currentRole,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                  style: TextStyle(
                    color: Color(0xFF527DAA),
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                )
              )
              )
        ],
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
          // save the fields..
          final form = _formKey.currentState;
          form.save();

          // Validate will return true if is valid, or false if invalid.
          if (form.validate()) {
            try {
              if(ADMIN == _currentRole){
                bool shouldContinue = await _buildWarningDialog(context);
                if(!shouldContinue){
                  return;
                }
              }
              await Provider.of<AuthService>(context, listen: kReleaseMode)
                  .createUser(firstName: _firstName, lastName: _lastName, user: _username, password: _password, userRole: _currentRole
                  , MDLSZ: _MDLSZ, serialNumber: _serialNumber, category: _category, division: _division);
              Navigator.pop(context);
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
          'Regisztrálás',
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

  Widget _buildConditionalFields() {
    if (COMPETITOR == _currentRole) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: _smallHeightConst,
            ),
            IntrinsicHeight (
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                      fit: FlexFit.loose,
                      child: _buildMDLSZTF()
                  ),
                  SizedBox(
                    width: _smallWidthConst,
                  ),
                  Flexible(
                      fit: FlexFit.loose,
                      child: _buildSerialNumberTF()
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _extraSmallHeightConst,
            ),
            IntrinsicHeight (
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                      fit: FlexFit.loose,
                      child: _buildCategoryTF()
                  ),
                  SizedBox(
                    width: _smallWidthConst,
                  ),
                  Flexible(
                      fit: FlexFit.loose,
                      child: _buildDivisionTF()
                  ),
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
    _smallWidthConst=  MediaQuery.of(context).size.width * 0.08;
    _mediumWidthConst =  MediaQuery.of(context).size.width * 0.2;
    _largeWidthConst =  MediaQuery.of(context).size.width * 0.3;
    _extraSmallHeightConst = MediaQuery.of(context).size.height * 0.03;
    _smallHeightConst = MediaQuery.of(context).size.height * 0.07;
    _formPadding = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Új résztvevő regisztrálása',
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
                          IntrinsicHeight (
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildEmailTF()
                                ),
                                SizedBox(
                                  width: _smallWidthConst,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildPasswordTF()
                                ),
                              ],
                          ),
                          ),
                          SizedBox(
                            height: _extraSmallHeightConst,
                          ),
                          IntrinsicHeight (
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildLastNameTF()
                                ),
                                SizedBox(
                                  width: _smallWidthConst,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: _buildFirstNameTF()
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _smallHeightConst,
                          ),
                          _buildRoleDropDown(),
                          _buildConditionalFields(),
                          _buildSignupBtn(),
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void changedDropDownItem(String selectedRole) {
    print("Selected role $selectedRole, we are going to refresh the UI");
    setState(() {
      _currentRole = selectedRole;
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
          content: Text("Biztosan még egy szervezőt akarsz regisztrálni, ADMIN jogkörrel?"),
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
