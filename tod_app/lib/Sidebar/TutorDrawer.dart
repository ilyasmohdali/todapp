import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Preferences/Teaching.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/notifier/usernotifier.dart';
import 'package:tod_app/screens/Profile/tutorProfile.dart';
import 'package:tod_app/Preferences/Consultation.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/Services/database.dart';

class TutorDrawer extends StatefulWidget{

  final String uid;
  TutorDrawer({this.uid});

  @override
  _TutorDrawerState createState() => new _TutorDrawerState();
}

class _TutorDrawerState extends State<TutorDrawer>{

  FirebaseUser user;
  String error;

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }




  final AuthenticationService _auth = AuthenticationService();


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<NewUser>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context,snapshot){
          if(snapshot.hasData){
            NewUser userData = snapshot.data;
    return Drawer(
      child: Column(
        children: <Widget>[
          Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 240.0,
                  color: Colors.red,
                ),
                Center(
                    child: Column(
                        children: <Widget>[
                          Container(
                            //alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 50.0, bottom: 10.0),
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: DecorationImage(
                                //image: AssetImage('assets/images/tod_logo.PNG')
                                  image: NetworkImage(userData.imageURL)
                                //image: NetworkImage(userNotifier.userList)
                              ),
                            ),
                          ),
                          Text(
                            //snapshot.data != null ? snapshot.data['userName'] : '', style: TextStyle(fontSize: 22.0, fontFamily: "Poppins", color: Colors.white
                              snapshot.data != null ? userData.userName : '', style: TextStyle(fontSize: 22.0, fontFamily: "Poppins", color: Colors.white)
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            //snapshot.data != null ? snapshot.data['email'] : '', style: TextStyle(fontSize: 18.0, fontFamily: "Poppins", color: Colors.white)
                              snapshot.data != null ? userData.email : '', style: TextStyle(fontSize: 16.0, fontFamily: "Poppins", color: Colors.white)
                          )
                        ])
                ),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TutorProfile()));
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
                      leading: Icon(Icons.perm_contact_calendar),
                      title: Text("Teaching Method", style: TextStyle(fontFamily: "Poppins-Bold", fontSize: 18.0),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Teaching()));
                      }
                  ),
                ),
              )
          ),
          SizedBox(
            height: 270.0,
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
    }else{
      return Loading();
    }
});
  }
}