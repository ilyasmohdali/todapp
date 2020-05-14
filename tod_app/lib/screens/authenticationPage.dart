import 'package:flutter/cupertino.dart';
import 'package:tod_app/screens/login_screen.dart';
import 'package:tod_app/screens/SignUpPage.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget{
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>{

  bool showSignIn = true;
  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Login(toggleView: toggleView);
    }
    else{
      return SignUpPage(toggleView: toggleView);
    }
  }
}