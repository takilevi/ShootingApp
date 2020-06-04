import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'authservice.dart';

class SignUpPage extends StatefulWidget {
  final FirebaseUser currentUser;

  SignUpPage(this.currentUser);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _username;
  String _firstName;
  String _lastName;
  String _MDLSZ;
  int _serialNumber;
  String _category;
  String _division;

  List<String> _userRoles =
  ["ADMIN", "JUDGE", "COMPETITOR"];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register user"),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    'User informations',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                      onSaved: (value) => _firstName = value,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "First name")),
                  TextFormField(
                      onSaved: (value) => _lastName = value,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Last name")),
                  TextFormField(
                      onSaved: (value) => _username = value,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: "Username")),
                  TextFormField(
                      onSaved: (value) => _password = value,
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password")),
                  SizedBox(height: 20.0),
                  DropdownButton(
                    value: _currentRole,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  ),
                  SizedBox(height: 20.0),
                  _buildChild(),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    child: Text("Sign up"),
                    onPressed: () async {
                      // save the fields..
                      final form = _formKey.currentState;
                      form.save();

                      // Validate will return true if is valid, or false if invalid.
                      if (form.validate()) {
                        try {
                          await Provider.of<AuthService>(context, listen: kReleaseMode)
                              .createUser(firstName: _firstName, lastName: _lastName, user: _username, password: _password, userRole: _currentRole
                              , MDLSZ: _MDLSZ, serialNumber: _serialNumber, category: _category, division: _division);
                        } on AuthException catch (error) {
                          return _buildErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          return _buildErrorDialog(context, error.toString());
                        } catch (error) {
                          return _buildErrorDialog(context, error.toString());
                        }
                      }
                    },
                  ),
                ]))));
  }

  Widget _buildChild() {
    if ("COMPETITOR" == _currentRole) {
      return new Column(
          children: <Widget>[
            TextFormField(
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                onSaved: (value) => _MDLSZ = value,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "MDLSZ")),
            TextFormField(
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                onSaved: (value) => _serialNumber = num.tryParse(value),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Serial number")),
            TextFormField(
                onSaved: (value) => _category = value,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Category")),
            TextFormField(
                onSaved: (value) => _division = value,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Division")),
          ]
      );
    } else {
      _MDLSZ = null;
      _serialNumber = null;
      _category = null;
      _division = null;
    }
    return new Column();
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
