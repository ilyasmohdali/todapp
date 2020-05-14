import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/screens/home.dart';
import 'package:tod_app/screens/SignUpPage.dart';

class MainDrawer extends StatefulWidget{

  @override
  _MainDrawerState createState() => new _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer>{

  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 220.0,
                color: Color(0xFF262AAA),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 50.0),
                        width: 90.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                          image: DecorationImage(
                            image: AssetImage("assets/images/tod.png")
                        ),
                      ),
                    ),
                ])
              )]
          ),
          Container(
            width: double.infinity,
              child: InkWell(
                  child: Material(
                    color: Colors.transparent,
                      child:ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Profile", style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 18.0),),
                          onTap: (){}
                  ),
              ),
            )
          ),
          Center(
            child:Container(
              width: double.infinity,
                child:InkWell(
                  child: Material(
                    color: Colors.transparent,
                    child:ListTile(
                      leading: Icon(Icons.power_settings_new),
                      title: Text("Logout", style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 18.0),),
                      onTap: () async {
                        await _auth.signOut();
                      }
                  ),
                ),
              )
          ))],
        ),
      );
  }
}