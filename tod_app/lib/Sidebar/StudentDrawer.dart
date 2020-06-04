import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/notifier/usernotifier.dart';
import 'package:tod_app/screens/Profile/studentProfile.dart';
import 'package:tod_app/screens/Consultation.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/Services/database.dart';

class StudentDrawer extends StatefulWidget{

  final String uid;
  StudentDrawer({this.uid});

  @override
  _StudentDrawerState createState() => new _StudentDrawerState();
}

class _StudentDrawerState extends State<StudentDrawer>{

 //DatabaseService databaseService;

  File _image;

  FirebaseUser user;
  String error;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  /*uploadImage(){
    var random = Random(25);
    final StorageReference
  }*/


  /*void setUser(FirebaseUser user) {
    setState(() {
      this.user = user;
      this.error = null;
    });
  }

  @override
  void initState() {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);
    databaseService.getCurrentUsers(userNotifier);
    super.initState();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then(setUser);
  }*/


  final AuthenticationService _auth = AuthenticationService();


  @override
  Widget build(BuildContext context) {

    //UserNotifier userNotifier = Provider.of<UserNotifier>(context);

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
                          color: Color(0xFF262AAA),
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
              )
          );
        }else{
          return Loading();
        }
      });
  }
}