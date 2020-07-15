import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/screens/Profile/AdminProfileUpdate.dart';
import 'package:tod_app/screens/home/student_list.dart';


class AdminProfile extends StatefulWidget{
  final String uid;
  AdminProfile({this.uid});

  _AdminProfileState createState() => new _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile>{

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<NewUser>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context,snapshot){
          if(snapshot.hasData) {
            NewUser userData = snapshot.data;
            return Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Color(0x44000000).withOpacity(0.0),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  elevation: 0.0,
                  title: Text('Profile', style: TextStyle(fontFamily: "Poppins",
                      fontSize: 20.0,
                      color: Colors.white)),
                ),
                //body: StudentList(),
                body: SingleChildScrollView(
                  child: Column(
                      children: <Widget>[
                        Stack(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 230.0,
                                color: Colors.black,
                              ),
                              Container(

                                child: Row(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(top: 100.0, bottom: 10.0, left: 30.0),
                                        width: 90.0,
                                        height: 90.0,
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
                                      Container(
                                          margin: EdgeInsets.only(top: 90.0),
                                          child: Column(
                                              children: <Widget>[
                                                Container(
                                                    margin: EdgeInsets.only(left: 30.0),
                                                    alignment : Alignment.centerLeft,
                                                    child: Text(
                                                      //snapshot.data != null ? snapshot.data['email'] : '', style: TextStyle(fontSize: 18.0, fontFamily: "Poppins", color: Colors.white)
                                                        snapshot.data != null ? userData.userName : '', style: TextStyle(fontSize: 20.0, fontFamily: "Poppins", color: Colors.white)
                                                    )),
                                                Container(
                                                    width: 230.0,
                                                    margin: EdgeInsets.only(top: 10.0, left: 30.0),
                                                    child: RaisedButton(
                                                      onPressed: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUpdateProfile()));
                                                      },
                                                      child: Text("Edit Profile", style: TextStyle(fontSize: 20.0, fontFamily: "Poppins", color: Colors.black)),
                                                    )
                                                )]))
                                    ]),
                              ),
                            ]
                        ),
                        /*Container(
                            padding: EdgeInsets.only(top: 15.0, left: 25.0),
                            alignment: Alignment.centerLeft,
                            child: Text("Location", style: TextStyle(fontSize: 22.0, fontFamily: "Poppins"),)),
                        InkWell(
                            child: Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(top: 16.0),
                                      //alignment: Alignment.centerLeft,
                                      height: 45.0,
                                      //width: double.infinity,
                                      child:Material(
                                        color: Colors.transparent,
                                        child: FlatButton(
                                          color: Color.fromARGB(0, 0, 0, 0),
                                          onPressed: () async {
                                            /*if (_formKey.currentState.validate()){
                                setState(() => loading = true);
                                dynamic result = await _auth.signInWithEmailandPassword(email, password);
                                if (result == null){
                                  setState(() {
                                    error = 'please supply a valid email';
                                    loading = false;
                                  });
                                }
                              }*/},
                                          child: Row(
                                              children: <Widget>[
                                                SizedBox(width: 5.0),
                                                Icon(Icons.home),
                                                SizedBox(width: 20.0),
                                                Text(
                                                    "Add Home",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "Poppins",
                                                        fontSize: 18.0,
                                                        letterSpacing: 1.0
                                                    )),
                                              ]),
                                        ),
                                      ))])),
                        Divider(color: Colors.black),
                        Container(
                            padding: EdgeInsets.only(top: 15.0, left: 25.0),
                            alignment: Alignment.centerLeft,
                            child: Text("Preferences", style: TextStyle(fontSize: 22.0, fontFamily: "Poppins"),)),
                        InkWell(
                            child: Column(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(top: 16.0),
                                      //alignment: Alignment.centerLeft,
                                      height: 45.0,
                                      //width: double.infinity,
                                      child:Material(
                                        color: Colors.transparent,
                                        child: FlatButton(
                                          color: Color.fromARGB(0, 0, 0, 0),
                                          onPressed: () async {
                                            /*if (_formKey.currentState.validate()){
                                setState(() => loading = true);
                                dynamic result = await _auth.signInWithEmailandPassword(email, password);
                                if (result == null){
                                  setState(() {
                                    error = 'please supply a valid email';
                                    loading = false;
                                  });
                                }
                              }*/},
                                          child: Row(
                                              children: <Widget>[
                                                SizedBox(width: 5.0),
                                                Icon(Icons.looks_one),
                                                SizedBox(width: 20.0),
                                                Text(
                                                    "Course",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "Poppins",
                                                        fontSize: 18.0,
                                                        letterSpacing: 1.0
                                                    )),

                                              ]),
                                        ),
                                      )
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 16.0),
                                      //alignment: Alignment.centerLeft,
                                      height: 45.0,
                                      //width: double.infinity,
                                      child:Material(
                                        color: Colors.transparent,
                                        child: FlatButton(
                                          color: Color.fromARGB(0, 0, 0, 0),
                                          onPressed: () async {
                                            /*if (_formKey.currentState.validate()){
                                setState(() => loading = true);
                                dynamic result = await _auth.signInWithEmailandPassword(email, password);
                                if (result == null){
                                  setState(() {
                                    error = 'please supply a valid email';
                                    loading = false;
                                  });
                                }
                              }*/},
                                          child: Row(
                                              children: <Widget>[
                                                SizedBox(width: 5.0),
                                                Icon(Icons.looks_two),
                                                SizedBox(width: 20.0),
                                                Text(
                                                    "Learning Method",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "Poppins",
                                                        fontSize: 18.0,
                                                        letterSpacing: 1.0
                                                    )),

                                              ]),
                                        ),
                                      )
                                  )
                                ]
                            )
                        ),
                        Divider(color: Colors.black)*/
                      ]),
                ) );
          }
          else{
            return Wrapper();
          }
        });
  }
}