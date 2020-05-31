import 'package:provider/provider.dart';
import 'package:tod_app/Services/database.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/screens/home/TutorHome.dart';
import 'package:tod_app/screens/home/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/screens/authenticationPage.dart';
import 'package:tod_app/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loading.dart';

class Wrapper extends StatefulWidget{
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  /*FirebaseUser user;
  String error;

  void setUser(FirebaseUser user) {
    setState(() {
      this.user = user;
      this.error = null;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then(setUser);
  }*/


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
            return Home();
          }
          else if(userData.userType == 'Tutor'){
            return TutorHome();
          }
            return AdminHome();
        }
      },
    );
  }
}