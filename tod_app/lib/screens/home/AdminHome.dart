import 'dart:collection';
import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tod_app/Sidebar/AdminDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/Services/database.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:rxdart/rxdart.dart';

class AdminHome extends StatefulWidget{
  final String uid;
  AdminHome({this.uid});

  @override
  _AdminHomeState createState() => _AdminHomeState();

}

class _AdminHomeState extends State<AdminHome>{

  FirebaseUser user;
  bool loading = false;

  @override


  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
      return loading ? Loading() : Scaffold(
        //extendBodyBehindAppBar: false,
        backgroundColor: Color(0xFFbee8f9),
        appBar: AppBar(
          title: Text("Admin Home"),
          backgroundColor: Color(0x44000000),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0.0,
        ),
        drawer: AdminDrawer(),
        body:ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20.0, top:12.0, bottom: 10.0),
                child:Text("List of User", style: TextStyle(fontSize: 20.0, fontFamily: "Poppins"))
              ),
              Container(
                child: StreamBuilder(
                  stream: Firestore.instance.collection('users').orderBy('userName', descending: false).snapshots(),
                  builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Wrapper();
                    }
                    final List<DocumentSnapshot> document = snapshot.data.documents;
                    return new ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: document.length,
                        itemBuilder: (context, index){
                          return Card(
                            child:  ListTile(
                              leading: CircleAvatar(backgroundImage: NetworkImage(document[index].data['imageURL'])),
                              title: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                children: <Widget>[
                                  SizedBox(height: 5.0,),
                                  Container(alignment: Alignment.centerLeft,
                                   child: Text(document[index].data['email']),),
                                  SizedBox(height: 5.0,),
                                  Container(alignment: Alignment.centerLeft,
                                   child:Text(document[index].data['userName'])),
                                  SizedBox(height: 5.0,)
                                  //Text(document[index].data['gender']),
                                ]),
                              ),
                              subtitle: Text(document[index].data['userType']),
                              trailing: Text(document[index].data['phoneNum']),
                              onTap: (){},
                            ),
                          );
                        }
                    );
                  })
        )],
      ));
    }
}