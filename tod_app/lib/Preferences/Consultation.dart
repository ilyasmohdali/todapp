import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/Services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tod_app/screens/displayTutor.dart';
import 'package:tod_app/Sidebar/StudentConsultationDrawer.dart';

class Consultation extends StatefulWidget {
  final String uid;
  final String userName;
  final String email;
  final String phoneNum;
  final Function userData;

  Consultation({this.uid,this.userName,this.email,this.phoneNum,this.userData});

  @override
  _ConsultationState createState() => new _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  FirebaseUser user;


  File _image;

  String uid;
  String email;
  String password;
  String userName;
  String phoneNum;
  String gender;
  String userType;
  String imageURL;
  String userPreference1;
  String userPreference2;
  String userPreference3;
  String tutorTeach1;
  String tutorTeach2;
  String tutorTeach3;
  String verified;
  String error = '';
  String _selectedType;
  String _selectedGender;
  bool loading = false;

  TextEditingController _userNameController;
  TextEditingController _emailController;
  TextEditingController _phoneNumController;

  String _selectedUPreference1;
  String _selectedUPreference2;
  String _selectedUPreference3;

  List <String> uPreference1 = <String> ['default','Video'];
  List <String> uPreference2 = <String> ['default','Audio'];
  List <String> uPreference3 = <String> ['default','Hands-On'];


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('_image: $_image');
    });
  }

  /*Future uploadPic(BuildContext context) async {
    String filename = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(filename);

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;


  }*/

  @override
  void initState() {
    super.initState();
    _userNameController = new TextEditingController(text: widget.userName);
    _emailController = new TextEditingController(text: widget.email);
    _phoneNumController = new TextEditingController(text: widget.phoneNum);
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<NewUser>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          NewUser userData = snapshot.data;
          if (snapshot.hasData) {
            return loading ? Loading() : Scaffold(
                appBar: AppBar(
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () async {
                          if (_image != null) {
                            setState(() => loading = true);
                            await DatabaseService(uid: widget.uid, file: _image).uploadImage(
                              uid ?? userData.id,
                              userName ?? userData.userName,
                              email ?? userData.email,
                              gender ?? userData.gender,
                              userType ?? userData.userType,
                              phoneNum ?? userData.phoneNum,
                              imageURL ?? userData.imageURL,
                              userPreference1 ?? userData.userPreference1,
                              userPreference2 ?? userData.userPreference2,
                              userPreference3 ?? userData.userPreference3,
                              tutorTeach1 ?? userData.tutorTeach1,
                              tutorTeach2 ?? userData.tutorTeach2,
                              tutorTeach3 ?? userData.tutorTeach3,
                              verified ?? userData.verified
                            );
                          }
                          else if(_formKey.currentState.validate()){
                            setState(() => loading = true);
                            await DatabaseService(uid: user.uid).updateStudentData(
                              uid ?? userData.id,
                              userName ?? userData.userName,
                              email ?? userData.email,
                              gender ?? userData.gender,
                              userType ?? userData.userType,
                              phoneNum ?? userData.phoneNum,
                              imageURL ?? userData.imageURL,
                              userPreference1 ?? userData.userPreference1,
                              userPreference2 ?? userData.userPreference2,
                              userPreference3 ?? userData.userPreference3,
                              tutorTeach1 ?? userData.tutorTeach1,
                              tutorTeach2 ?? userData.tutorTeach2,
                              tutorTeach3 ?? userData.tutorTeach3,
                              verified ?? userData.verified,
                            );
                          }
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayTutor(userP1: userPreference1, userP2: userPreference2, userP3: userPreference3,)));
                          Navigator.pop(context);
                        },
                      )
                    ],
                    backgroundColor: Color(0xFF262AAA),
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    elevation: 0.0,
                    title: Text('Consultation',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 22.0,
                            color: Colors.white))),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Column(children: <Widget>[
                            Container(
                              //alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                              width: 90.0,
                              height: 90.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                                image: DecorationImage(
                                  //image: AssetImage('assets/images/tod_logo.PNG')
                                    image: _image != null ? FileImage(_image) : NetworkImage(userData.imageURL)
                                  //image: NetworkImage(userNotifier.userList)
                                ),
                              ),
                            ),
                            InkWell(
                              highlightColor: Colors.white,
                              //onTap: _getImage,
                              child: Text(userData.userName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontSize: 18.0,
                                    //fontSize: ScreenUtil().setSp(28)
                                  )),
                            ),
                          ])),
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20.0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Set Preference 1 (Learning Method)",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 18.0,
                                              color: Colors.black))),
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    hint: Text('Preference 1', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.0)),
                                    validator: (value) => value==null ? 'Preference 1' : null,
                                    value: _selectedUPreference1,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedUPreference1 = newValue;
                                        userPreference1 = _selectedUPreference1;
                                      });
                                    },
                                    items: uPreference1.map((preference1) {
                                      return DropdownMenuItem(
                                        child: new Text(preference1),
                                        value: preference1,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20.0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Set Preference 2 (Learning Method)",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 18.0,
                                              color: Colors.black))),
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    hint: Text('Preference 2', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.0)),
                                    validator: (value) => value==null ? 'Preference 2' : null,
                                    value: _selectedUPreference2,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedUPreference2 = newValue;
                                        userPreference2 = _selectedUPreference2;
                                      });
                                    },
                                    items: uPreference2.map((preference2) {
                                      return DropdownMenuItem(
                                        child: new Text(preference2),
                                        value: preference2,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20.0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Set Preference 3 (Learning Method)",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 18.0,
                                              color: Colors.black))),
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    hint: Text('Preference 3', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.0)),
                                    validator: (value) => value==null ? 'Preference 3' : null,
                                    value: _selectedUPreference3,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedUPreference3 = newValue;
                                        userPreference3 = _selectedUPreference3;
                                      });
                                    },
                                    items: uPreference3.map((preference3) {
                                      return DropdownMenuItem(
                                        child: new Text(preference3),
                                        value: preference3,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ]))
                    ],
                  ),
                ));
          } else {
            return Wrapper();
          }
        });

  }

}


/*class DisplayTutor extends StatefulWidget{
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
  void initState() {
    //showAllTutorVDD();
    super.initState();
  }

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
          drawer: StudentConsultationDrawer(),
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
    //final user = Provider.of<User>(context);
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
    //final user = Provider.of<User>(context);
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
    //final user = Provider.of<User>(context);
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
    //final user = Provider.of<User>(context);
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
    //final user = Provider.of<User>(context);
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
    //final user = Provider.of<User>(context);
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
    //final user = Provider.of<User>(context);
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
    //final user = Provider.of<User>(context);
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

}*/
