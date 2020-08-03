import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/screens/Profile/studentProfileUpdate.dart';
import 'package:tod_app/screens/home/student_list.dart';


class StudentProfile extends StatefulWidget{
  final String uid;
  StudentProfile({this.uid});

  _StudentProfileState createState() => new _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile>{

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
                        color: Color(0xFF262AAA),
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => StudentUpdateProfile()));
                                        },
                                        child: Text("Edit Profile", style: TextStyle(fontSize: 20.0, fontFamily: "Poppins", color: Colors.black)),
                                      )
                                  )]))
                            ]),
                    ),
                    ]
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Text("Current Learning Method", style: TextStyle(fontFamily: "Poppins", fontSize: 20.0),),
                ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("1",style: TextStyle(fontSize: 16.0,fontFamily: "Poppins")),
                            Text("   "),
                            Text(userData.userPreference1, style: TextStyle(fontSize: 16.0,fontFamily: "Poppins"))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("2",style: TextStyle(fontSize: 16.0,fontFamily: "Poppins")),
                            Text("  "),
                            Text(userData.userPreference2, style: TextStyle(fontSize: 16.0,fontFamily: "Poppins"))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("3",style: TextStyle(fontSize: 16.0,fontFamily: "Poppins")),
                            Text("  "),
                            Text(userData.userPreference3, style: TextStyle(fontSize: 16.0,fontFamily: "Poppins"))
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
              ) );
          }
          else{
            return Wrapper();
          }
        });
  }
}