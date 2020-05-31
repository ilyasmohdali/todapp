import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/screens/home/home.dart';
import 'package:tod_app/screens/SignUpPage.dart';
import 'package:tod_app/screens/userProfile.dart';
import 'package:tod_app/screens/Consultation.dart';
import 'package:tod_app/models/user.dart';

class TutorDrawer extends StatefulWidget{


  @override
  _TutorDrawerState createState() => new _TutorDrawerState();
}

class _TutorDrawerState extends State<TutorDrawer>{

  FirebaseUser user;
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

  }



  final AuthenticationService _auth = AuthenticationService();


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Drawer(
      child: Column(
        children: <Widget>[
          Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 220.0,
                  color: Colors.red,
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
                )

              ]
          ),
          Container(
              width: double.infinity,
              child: InkWell(
                child: Material(
                  color: Colors.transparent,
                  child:ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Profile", style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 18.0),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()));
                      }
                  ),
                ),
              )
          ),
          Container(
              width: double.infinity,
              child: InkWell(
                child: Material(
                  color: Colors.transparent,
                  child:ListTile(
                      leading: Icon(Icons.phone_in_talk),
                      title: Text("Consultations", style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 18.0),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Consultation()));
                      }
                  ),
                ),
              )
          ),
          SizedBox(
            height: 290.0,
          ),
          Container(
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
          )],
      ),
    );
  }
}