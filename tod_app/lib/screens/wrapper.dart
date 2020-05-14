import 'package:provider/provider.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:flutter/material.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/screens/authenticationPage.dart';
import 'package:tod_app/screens/home.dart';
import 'package:tod_app/screens/login_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    //return Home or Authentication Widget
    if(user == null){
      return AuthenticationPage();
    }
    else{
      return Home();
    }
  }
}