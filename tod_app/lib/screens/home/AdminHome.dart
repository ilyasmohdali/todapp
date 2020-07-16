import 'dart:collection';
import 'dart:async';
//import 'dart:js';

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
                  stream: Firestore.instance.collection('users').where('userType', isEqualTo: 'Tutor').snapshots(),
                  builder: (context,snapshot) {
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
                              subtitle: Row(children: <Widget>[
                                Text(document[index].data['userType']),
                                Text(" "),
                                Text("Verified: "),
                                Text(document[index].data['verified']),
                              ],
                              ),
                              trailing: Text(document[index].data['phoneNum']),
                              onTap: (){changeVerify(document[index].data['uid']);},
                            ),
                          );
                        }
                    );
                  })
        )],
      ));
    }

  void changeVerify(String uid){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0)
            )
        ),
        context: context,
        builder: (builder){
          return StreamBuilder(
              stream: Firestore.instance.collection('users').document(uid).snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Loading();
                }
                return new Container(
                  height: 250.0,
                  child: new Container(
                    padding: EdgeInsets.fromLTRB(20.0, 3, 30.0, 5.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 80.0,
                                  height: 80.0,
                                  margin: EdgeInsets.only(top: 35.0, bottom: 7.0, left: 10.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: NetworkImage(snapshot.data['imageURL']),
                                    fit: BoxFit.fill),
                                  ),
                                )
                              ],),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: 220,
                                margin: EdgeInsets.only(top:26, left: 14),
                                child: Text(snapshot.data['userName'], textAlign: TextAlign.left,style: TextStyle( fontSize: 24, fontFamily: 'Poppins')),
                              ),
                                Container(
                                  width: 220,
                                  margin: EdgeInsets.only(top:4, left: 15),
                                  child: Text(snapshot.data['email'], style: TextStyle( fontSize: 16)),
                                ),
                                Container(
                                  width: 220,
                                  margin: EdgeInsets.only(top:3, left: 15),
                                  child: Text(snapshot.data['phoneNum'], style: TextStyle( fontSize: 16)),
                                )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0,),
                        Visibility(
                          visible: (snapshot.data['verified'].toString() == 'No')? true : false,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 55.0,
                                width: 300.0,
                                child: RaisedButton(
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0)
                                  ),
                                  color: Colors.blue,
                                  child: Text("Verify User", style: TextStyle(fontFamily: "Poppins", fontSize: 20.0, color: Colors.white),),
                                  onPressed: () async {
                                    Firestore.instance.collection('users').document(uid).updateData({
                                      'verified': 'Yes'
                                    }).whenComplete((){
                                      Navigator.pop(context);
                                    });
                                  },
                              )
                              )],
                          ),
                        ),
                        Visibility(
                          visible: (snapshot.data['verified'].toString() == 'Yes')? true : false,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                  height: 55.0,
                                  width: 300.0,
                                  child: RaisedButton(
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2.0)
                                    ),
                                    color: Colors.blue,
                                    child: Text("Unverify User", style: TextStyle(fontFamily: "Poppins", fontSize: 20.0, color: Colors.white),),
                                    onPressed: () async {
                                      Firestore.instance.collection('users').document(uid).updateData({
                                        'verified': 'No'
                                      }).whenComplete((){
                                        Navigator.pop(context);
                                      });
                                    },
                                  )
                              )],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}

