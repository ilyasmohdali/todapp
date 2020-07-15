//import 'dart:collection';
//import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tod_app/Sidebar/AdminDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tod_app/Sidebar/TutorDrawer.dart';
import 'package:tod_app/Sidebar/StudentDrawer.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/Services/database.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tod_app/screens/home/StudentHome.dart';
import 'package:tod_app/Sidebar/StudentConsultationDrawer.dart';

class DisplayTutor extends StatefulWidget{
    final String uid;
    final String userP1, userP2, userP3;
    DisplayTutor({this.uid, this.userP1, this.userP2, this.userP3});

    @override
    _DisplayTutorState createState() => _DisplayTutorState();

    }

    class _DisplayTutorState extends State<DisplayTutor>{

    FirebaseUser user;

    bool loading = false;



    @override

    Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
    if(widget.userP1 == 'Video' && widget.userP2 == 'default' && widget.userP3 == 'default') {
    return loading ? Loading() : Scaffold(
    //extendBodyBehindAppBar: false,
    backgroundColor: Color(0xFFbee8f9),
    appBar: AppBar(
    title: Text("Suggested Tutor"),
    backgroundColor: Color(0x44000000),
    iconTheme: IconThemeData(
    color: Colors.black,
    ),
    elevation: 0.0,
    ),
    drawer: StudentConsultationDrawer(uid: user.uid),
    body: ListView(
    children: <Widget>[
    Container(
    padding: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 10.0),
    child: Text("List of Tutors",
    style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
    ),
    Container(
    child: showAllTutorVDD()
    )
    ],
    ));
    }
    else if(widget.userP1 == 'default' && widget.userP2 == 'Audio' && widget.userP3 == 'default'){
    {
    return loading ? Loading() : Scaffold(
    //extendBodyBehindAppBar: false,
    backgroundColor: Color(0xFFbee8f9),
    appBar: AppBar(
    title: Text("Suggested Tutor"),
    backgroundColor: Color(0x44000000),
    iconTheme: IconThemeData(
    color: Colors.black,
    ),
    elevation: 0.0,
    ),
    drawer: StudentConsultationDrawer(),
    body: ListView(
    children: <Widget>[
    Container(
    padding: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 10.0),
    child: Text("List of Tutors",
    style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
    ),
    Container(
    child: showAllTutorDAD()
    )
    ],
    ));
    }
    }
    else if(widget.userP1 == 'default' && widget.userP2 == 'default' && widget.userP3 == 'Hands-On'){
    {
    return loading ? Loading() : Scaffold(
    //extendBodyBehindAppBar: false,
    backgroundColor: Color(0xFFbee8f9),
    appBar: AppBar(
    title: Text("Suggested Tutor"),
    backgroundColor: Color(0x44000000),
    iconTheme: IconThemeData(
    color: Colors.black,
    ),
    elevation: 0.0,
    ),
    drawer: StudentConsultationDrawer(),
    body: ListView(
    children: <Widget>[
    Container(
    padding: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 10.0),
    child: Text("List of Tutors",
    style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
    ),
    Container(
    child: showAllTutorDDK()
    )
    ],
    ));
    }
    }
    else if(widget.userP1 == 'Video' && widget.userP2 == 'Audio' && widget.userP3 == 'default'){
    //if(widget.userP2 =='Audio')

    return loading ? Loading() : Scaffold(
    //extendBodyBehindAppBar: false,
    backgroundColor: Color(0xFFbee8f9),
    appBar: AppBar(
    title: Text("Suggested Tutor"),
    backgroundColor: Color(0x44000000),
    iconTheme: IconThemeData(
    color: Colors.black,
    ),
    elevation: 0.0,
    ),
    drawer: StudentConsultationDrawer(),
    body: ListView(
    children: <Widget>[
    Container(
    padding: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 10.0),
    child: Text("List of Tutors",
    style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
    ),
    Container(
    child: showAllTutorVAD()
    )
    ],
    ));

    }

    else if(widget.userP1 == 'Video' && widget.userP2 == 'default' && widget.userP3 == 'Hands-On'){
    {
    return loading ? Loading() : Scaffold(
    //extendBodyBehindAppBar: false,
    backgroundColor: Color(0xFFbee8f9),
    appBar: AppBar(
    title: Text("Suggested Tutor"),
    backgroundColor: Color(0x44000000),
    iconTheme: IconThemeData(
    color: Colors.black,
    ),
    elevation: 0.0,
    ),
    drawer: StudentConsultationDrawer(),
    body: ListView(
    children: <Widget>[
    Container(
    padding: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 10.0),
    child: Text("List of Tutors",
    style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
    ),
    Container(
    child: showAllTutorVDK()
    )
    ],
    ));
    }
    }

    else if(widget.userP1 == 'default' && widget.userP2 == 'Audio' && widget.userP3 == 'Hands-On'){
    {
    return loading ? Loading() : Scaffold(
    //extendBodyBehindAppBar: false,
    backgroundColor: Color(0xFFbee8f9),
    appBar: AppBar(
    title: Text("Suggested Tutor"),
    backgroundColor: Color(0x44000000),
    iconTheme: IconThemeData(
    color: Colors.black,
    ),
    elevation: 0.0,
    ),
    drawer: StudentConsultationDrawer(),
    body: ListView(
    children: <Widget>[
    Container(
    padding: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 10.0),
    child: Text("List of Tutors",
    style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
    ),
    Container(
    child: showAllTutorDAK()
    )
    ],
    ));
    }
    }

    else if(widget.userP1 == 'Video' && widget.userP2 == 'Audio' && widget.userP3 == 'Hands-On'){
    {
    return loading ? Loading() : Scaffold(
    //extendBodyBehindAppBar: false,
    backgroundColor: Color(0xFFbee8f9),
    appBar: AppBar(
    title: Text("Suggested Tutor"),
    backgroundColor: Color(0x44000000),
    iconTheme: IconThemeData(
    color: Colors.black,
    ),
    elevation: 0.0,
    ),
    drawer: StudentConsultationDrawer(),
    body: ListView(
    children: <Widget>[
    Container(
    padding: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 10.0),
    child: Text("List of Tutors",
    style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
    ),
    Container(
    child: showAllTutorVAK()
    )
    ],
    ));
    }
    }

    //else if(widget.userP1 == 'default' && widget.userP2 == 'default' && widget.userP3 == 'default'){
    else{
    return loading ? Loading() : Scaffold(
    //extendBodyBehindAppBar: false,
    backgroundColor: Color(0xFFbee8f9),
    appBar: AppBar(
    title: Text("Suggested Tutor"),
    backgroundColor: Color(0x44000000),
    iconTheme: IconThemeData(
    color: Colors.black,
    ),
    elevation: 0.0,
    ),
    drawer: StudentConsultationDrawer(),
    body: ListView(
    children: <Widget>[
    Container(
    padding: EdgeInsets.only(left: 20.0, top: 12.0, bottom: 10.0),
    child: Text("List of Tutors",
    style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
    ),
    Container(
    child: showAllTutorDDD()
    )
    ],
    ));
    }
    /*else{
      return Wrapper();
    }*/
    }















    showAllTutorDDD() {
    final user = Provider.of<User>(context);
    return StreamBuilder(
    stream: Firestore.instance.collection('users').where('userType', isEqualTo: 'Tutor').snapshots(),
    //stream: DatabaseService(uid: user.uid).userData,
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Wrapper();
    }
    final List<DocumentSnapshot> document = snapshot.data.documents;
    //NewUser userData = snapshot.data;
    //if(userData.userType == 'Tutor') {
    return new ListView.builder(
    physics: ScrollPhysics(),
    shrinkWrap: true,
    itemCount: document.length,
    itemBuilder: (BuildContext context, int index) {
    //for(index; index<document.length; index++) {
    //if (document[index].data['userType']=='Tutor') {
    return Card(
    child: ListTile(
    leading: CircleAvatar(
    backgroundImage: NetworkImage(document[index].data['imageURL'])),
    //backgroundImage: NetworkImage(userData.imageURL)),
    title: Text(document[index].data['email']),
    //title: Text(userData.email),
    subtitle: Row(
    children: <Widget>[
    Text(document[index].data['tutorTeach1']),
    Text(" "),
    Text(document[index].data['tutorTeach2']),
    Text(" "),
    Text(document[index].data['tutorTeach3']),
    //Text(userData.tutorTeach1),
    ],),
    trailing: Text(document[index].data['phoneNum']),
    //trailing: Text(userData.phoneNum),
    ));
    //}
    },
    );
    //}
    });
    }


    showAllTutorVDD(){
    final user = Provider.of<User>(context);
    return StreamBuilder(
    stream: Firestore.instance.collection('users').where('tutorTeach1', isEqualTo: 'Visual').snapshots(),
    //stream: DatabaseService(uid: user.uid, tutorTeach1: widget.userP1).userData,
    builder: (context, snapshot) {
    //NewUser userData = snapshot.data;
    if (!snapshot.hasData) {
    return Wrapper();
    }
    final List<DocumentSnapshot> document = snapshot.data.documents;
    return new ListView.builder(
    physics: ScrollPhysics(),
    shrinkWrap: true,
    //semanticChildCount: document.length,
    //itemCount: document.length,
    itemCount: document.length,
    itemBuilder: (context, index){
    //for(index; index<document.length; index++){
    //if (document[index].data['tutorTeach1'] == 'Visual' && document[index].data['userType'] == 'Tutor'){
    return Card(
    child: ListTile(
    leading: CircleAvatar(
    backgroundImage: NetworkImage(
    document[index].data['imageURL'])),
    title: Text(document[index].data['email']),
    subtitle: Row(
    children: <Widget>[
    Text(document[index].data['tutorTeach1']),
    //Text(document[index].data['tutorTeach2']),
    ],),
    trailing: Text(document[index].data['phoneNum']),
    ));
    //}
    // }
    });
    });
    }

    showAllTutorDAD(){
    final user = Provider.of<User>(context);
    return StreamBuilder(
    stream: Firestore.instance.collection('users').where('tutorTeach2', isEqualTo: 'Auditory').snapshots(),
    builder: (context,
    AsyncSnapshot <QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
    return Wrapper();
    }
    final List<DocumentSnapshot> document = snapshot.data
        .documents;
    return new ListView.builder(
    physics: ScrollPhysics(),
    shrinkWrap: true,
    //semanticChildCount: document.length,
    itemCount: document.length,
    itemBuilder: (context, index){
    //for(index; index<document.length; index++){
    //if (document[index].data['tutorTeach1'] == 'Visual' && document[index].data['userType'] == 'Tutor'){
    return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  document[index].data['imageURL'])),
                          title: Text(document[index].data['email']),
                          subtitle: Row(
                            children: <Widget>[
                              Text(document[index].data['tutorTeach2']),
                            ],),
                          trailing: Text(document[index].data['phoneNum']),
                        ));
                  //}
                //}
        });
        });
  }

    showAllTutorDDK(){
    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('users').where('tutorTeach3', isEqualTo: 'Kinesthetic').snapshots(),
        builder: (context,
            AsyncSnapshot <QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Wrapper();
          }
          final List<DocumentSnapshot> document = snapshot.data
              .documents;
          return new ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              //semanticChildCount: document.length,
              itemCount: document.length,
              itemBuilder: (context, index){
                //for(index; index<document.length; index++){
                 // if (document[index].data['tutorTeach1'] == 'Visual' && document[index].data['userType'] == 'Tutor'){
                    return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  document[index].data['imageURL'])),
                          title: Text(document[index].data['email']),
                          subtitle: Row(
                            children: <Widget>[
                              Text(document[index].data['tutorTeach3']),
                            ],),
                          trailing: Text(document[index].data['phoneNum']),
                        ));
                //  }
              //  }
              });
        });
  }




    showAllTutorVAD(){
    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('users').where('tutorTeach1', isEqualTo: 'Visual').where('tutorTeach2', isEqualTo: 'Auditory').snapshots(),
        builder: (context,
            AsyncSnapshot <QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Wrapper();
          }
          final List<DocumentSnapshot> document = snapshot.data
              .documents;
          return new ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              //semanticChildCount: document.length,
              itemCount: document.length,
              itemBuilder: (context, index){
                //for(index; index<document.length; index++){
                  //if (document[index].data['tutorTeach1'] == 'Visual' && document[index].data['userType'] == 'Tutor'){
                //print(document[index].data['email']);
                    return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  document[index].data['imageURL'])),
                          title: Text(document[index].data['email']),
                          subtitle: Row(
                            children: <Widget>[
                              Text(document[index].data['tutorTeach1']),
                              Text(" "),
                              Text(document[index].data['tutorTeach2']),
                            ],),
                          trailing: Text(document[index].data['phoneNum']),

                        ));
                  //}
  //              }
  });

        });
  }

    showAllTutorDAK(){
    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('users').where('tutorTeach2', isEqualTo: 'Auditory').where('tutorTeach3', isEqualTo: 'Kinesthetic').snapshots(),
        builder: (context,
            AsyncSnapshot <QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Wrapper();
          }
          final List<DocumentSnapshot> document = snapshot.data
              .documents;
          return new ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              //semanticChildCount: document.length,
              itemCount: document.length,
              itemBuilder: (context, index){
                //for(index; index<document.length; index++){
                  //if (document[index].data['tutorTeach1'] == 'Visual' && document[index].data['userType'] == 'Tutor'){
                    return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  document[index].data['imageURL'])),
                          title: Text(document[index].data['email']),
                          subtitle: Row(
                            children: <Widget>[
                              Text(document[index].data['tutorTeach2']),
                              Text(" "),
                              Text(document[index].data['tutorTeach3']),
                            ],),
                          trailing: Text(document[index].data['phoneNum']),
                        ));
                  //}
                //}
              });
        });
  }

  showAllTutorVDK(){
    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('users').where('tutorTeach1', isEqualTo: 'Visual').where('tutorTeach3', isEqualTo: 'Kinesthetic').snapshots(),
        builder: (context,
            AsyncSnapshot <QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Wrapper();
          }
          final List<DocumentSnapshot> document = snapshot.data
              .documents;
          return new ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              //semanticChildCount: document.length,
              itemCount: document.length,
              itemBuilder: (context, index){
                //for(index; index<document.length; index++){
                  //if (document[index].data['tutorTeach1'] == 'Visual' && document[index].data['userType'] == 'Tutor'){
                    return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  document[index].data['imageURL'])),
                          title: Text(document[index].data['email']),
                          subtitle: Row(
                            children: <Widget>[
                              Text(document[index].data['tutorTeach1']),
                              Text(" "),
                              Text(document[index].data['tutorTeach3']),
                            ],),
                          trailing: Text(document[index].data['phoneNum']),
                        ));
                  //}
        //        }
        });
        });
  }

  showAllTutorVAK(){
    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('users').where('tutorTeach1', isEqualTo: 'Visual').where('tutorTeach2', isEqualTo: 'Auditory').where('tutorTeach3', isEqualTo: 'Kinesthetic').snapshots(),
        builder: (context,
            AsyncSnapshot <QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Wrapper();
          }
          final List<DocumentSnapshot> document = snapshot.data
              .documents;
          return new ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              //semanticChildCount: document.length,
              itemCount: document.length,
              itemBuilder: (context, index){
                //for(index; index<document.length; index++){
                  //if (document[index].data['tutorTeach1'] == 'Visual' && document[index].data['tutorTeach2'] == 'Audio' && document[index].data['tutorTeach1'] == 'Kinesthetic'){
                    return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  document[index].data['imageURL'])),
                          title: Text(document[index].data['email']),
                          subtitle: Row(
                            children: <Widget>[
                              Text(document[index].data['tutorTeach1']),
                              Text(" "),
                              Text(document[index].data['tutorTeach2']),
                              Text(" "),
                              Text(document[index].data['tutorTeach3']),
                            ],),
                          trailing: Text(document[index].data['phoneNum']),
                        ));
                  //}
        //        }
        });
        });
  }

}