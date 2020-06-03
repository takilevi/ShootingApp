import 'package:flutter/material.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page Flutter Firebase"),
      ),
      body: Container(
      padding: EdgeInsets.all(20.0),
      child: Form(          // <= NEW
      key: _formKey,      // <= NEW
      child: Column(
      children: <Widget>[
            SizedBox(height: 20.0),    // <= NEW
            Text(
              'Login Information',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20.0),   // <= NEW
            TextFormField(
                onSaved: (value) => _username = value,    // <= NEW
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Username")),
            TextFormField(
                onSaved: (value) => _password = value, // <= NEW
                obscureText: true,
                decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20.0),  // <= NEW
            RaisedButton(child: Text("LOGIN"), onPressed: () {
              // save the fields..
              final form = _formKey.currentState;
              form.save();

              // Validate will return true if is valid, or false if invalid.
              if (form.validate()) {
                print("$_username $_password");
                Provider.of<AuthService>(context, listen: false).loginUser(_username,_password);
              }
            }),
          ],
        ),
      ),
      ),
    );
  }
}


