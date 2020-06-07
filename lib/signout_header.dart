import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shootingapp/authservice.dart';

class SignOutHeader extends StatefulWidget {
  const SignOutHeader({Key key}) : super(key: key);

  @override
  _SignOutHeaderState createState() => _SignOutHeaderState();
}

class _SignOutHeaderState extends State<SignOutHeader> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Transform.rotate(
        angle: 180 * pi / 180,
        child: IconButton(
          padding: EdgeInsets.only(left: 0.0,right: 0.0, top:10.0, bottom: 10.0),
          icon: Icon(Icons.exit_to_app),
          iconSize: MediaQuery.of(context).size.height * 0.055,
          color: Colors.white,
          tooltip: 'Kijelentkezés',
          autofocus: true,
          onPressed: () async {
            await Provider.of<AuthService>(context, listen: kReleaseMode)
                .logout();
          },
        ),
      ),
    );
  }
}
