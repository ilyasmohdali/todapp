import 'package:provider/provider.dart';
import 'package:tod_app/Services/database.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/screens/Authentication/login_screen.dart';
import 'package:tod_app/screens/home/TutorHome.dart';
import 'package:tod_app/screens/home/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/screens/Authentication/authenticationPage.dart';
import 'package:tod_app/screens/home/StudentHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tod_app/screens/notVerified.dart';
import 'loading.dart';

class Wrapper extends StatefulWidget{
  final String uid;

  Wrapper({this.uid});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    //print(user.uid);

    //return Home or Authentication Widget
    if(user == null){
      return AuthenticationPage();
    }
    return StreamBuilder<NewUser>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Loading();
        }
        else{
          NewUser userData = snapshot.data;
          if(userData.userType == 'Student'){
            return StudentHome(uid: widget.uid,);
          }
          else if(userData.userType == 'Tutor' && userData.verified =='Yes'){
            return TutorHome();
          }
          else if(userData.userType == 'Tutor' && userData.verified == 'No'){
            return TutorHomeNotVerified();
          }
            return AdminHome();
        }
      },
    );
  }
}