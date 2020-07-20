import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/models/UserLocation.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/screens/Location/addhome.dart';
import 'package:tod_app/screens/Profile/TutorProfileUpdate.dart';
import 'package:tod_app/screens/home/student_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TutorProfile extends StatefulWidget{
  final String uid;
  final String docID;
  TutorProfile({this.uid,this.docID});

  _TutorProfileState createState() => new _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile>{

  FirebaseUser user;

  String uid, docID;

  getAddress(){
    Firestore.instance.collection('locations').getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        String resultAddress = '';
        int i;
        for( i=0; i<docs.documents.length; i++) {
          resultAddress = docs.documents[i].data['resultAddress'];
        }
        return Text("$resultAddress");
      }
      else{
        return Container(child:Text("hello"));
      }
    });
  }



  @override
  void initState() {
    getAddress();
    super.initState();
  }

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
                        //Visibility(visible: document,),

                        Stack(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 230.0,
                                color: Colors.red,
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
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TutorUpdateProfile()));
                                                      },
                                                      child: Text("Edit Profile", style: TextStyle(fontSize: 20.0, fontFamily: "Poppins", color: Colors.black)),
                                                    )
                                                )]))
                                    ]),
                              ),
                            ]
                        ),
                        Container(
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
                                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AddHome()));},
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
                                                //Text(getAddress(uid, docID))
                                              ]),
                                        ),
                                      ))
                                ])),
                        Divider(color: Colors.black),
                          Container(
                          color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                StreamBuilder(
                                  //stream: DatabaseService(uid: user.uid).locationData,
                                    stream: Firestore.instance.collection('locations').where('id', isEqualTo: user.uid).snapshots(),
                                    builder: (context, snapshot){
                                      if(!snapshot.hasData){
                                        return Wrapper();
                                      }
                                      final List<DocumentSnapshot> document = snapshot.data.documents;
                                      return ListView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: document.length,
                                          itemBuilder:(context, index){
                                            /*return Column(children: <Widget>[
                                          Text(document[index].data['docID']),
                                          Text(document[index].data['resultAddress']),

                                        ],);*/
                                            return Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(left: 20.0),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                      "Address",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "Poppins",
                                                          fontSize: 20.0,
                                                          letterSpacing: 1.0
                                                      )),
                                                ),
                                                Card(
                                                  child: ListTile(
                                                    title: Text(document[index].data['resultAddress']),
                                                    trailing: FlatButton(
                                                      child: Icon(Icons.delete),
                                            onPressed: () {
                                              /*Firestore.instance.collection(
                                                  'locations').where('id', isEqualTo: user.uid).getDocuments().then((snapshot){
                                                  for (int i = 0; i < snapshot.documents.length; i++){
                                                    snapshot.documents[i].reference.delete();
                                                  }
                                                });*/
                                              Firestore.instance.collection(
                                                  'locations').where('id', isEqualTo: user.uid).getDocuments().then((snapshot){

                                                  snapshot.documents.elementAt(index).reference.delete();

                                              });
                                            }),
                                            ),
                                            )
                                              ],
                                            );
                                          }
                                      );
                                    }
                                )
                              ],
                            )
                          )
                          /*child: Container(
                            color: Colors.blueAccent,
                            child: StreamBuilder(
                              //stream: DatabaseService(uid: user.uid).locationData,
                                stream: Firestore.instance.collection('locations').where('id', isEqualTo: user.uid).snapshots(),
                                builder: (context, snapshot){
                                  if(!snapshot.hasData){
                                    return Wrapper();
                                  }
                                  final List<DocumentSnapshot> document = snapshot.data.documents;
                                  return ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                      itemCount: document.length,
                                      itemBuilder:(context, index){
                                        /*return Column(children: <Widget>[
                                          Text(document[index].data['docID']),
                                          Text(document[index].data['resultAddress']),

                                        ],);*/
                                        return Card(
                                          child: ListTile(
                                            title: Text(document[index].data['resultAddress']),
                                          ),
                                        );
                                      }
                                  );
                                }
                            ),
                          ),*/

                      ]),
                ));
          }

          else{
            return Wrapper();
          }
        });
  }

/*getSetAddress(Coordinates coordinates) async {
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _resultAddress = addresses.first.addressLine;
    });
  }*/

}