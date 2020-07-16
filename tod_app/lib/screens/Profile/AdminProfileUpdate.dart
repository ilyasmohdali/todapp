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

class AdminUpdateProfile extends StatefulWidget {
  final String uid;
  final String userName;
  final String email;
  final String phoneNum;
  final Function userData;

  AdminUpdateProfile({this.uid,this.userName,this.email,this.phoneNum,this.userData});

  @override
  _AdminUpdateProfileState createState() => new _AdminUpdateProfileState();
}

class _AdminUpdateProfileState extends State<AdminUpdateProfile> {
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

  List <String> genderList = <String> ['Male','Female'];
  List <String> uType = <String> ['Student','Tutor'];

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
                              verified ?? userData.verified
                            );
                          }
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    backgroundColor: Colors.black,
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    elevation: 0.0,
                    title: Text('Edit Profile',
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
                              onTap: _getImage,
                              child: Text("Change Profile Picture",
                                  style: TextStyle(
                                    color: Colors.blue,
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
                                      child: Text("Username",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 18.0,
                                              color: Colors.black))),
                                  TextFormField(
                                    initialValue: userData.userName,
                                    //controller: _userNameController,
                                    validator: (value) => value.isEmpty ? 'Enter a Username' : null,
                                    onChanged: (value){
                                      setState(() => userName = value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Username",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                  )
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
                                      child: Text("Email",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 18.0,
                                              color: Colors.black))),
                                  TextFormField(
                                    initialValue: userData.email,
                                    //controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) => value.isEmpty ? 'Enter an Email' : null,
                                    onChanged: (value){
                                      setState(() => email = value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                  )
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
                                      child: Text("Phone Number",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 18.0,
                                              color: Colors.black))),
                                  TextFormField(
                                    initialValue: userData.phoneNum,
                                    //controller: _phoneNumController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value.isEmpty ? 'Enter your Phone Number' : null,
                                    onChanged: (value){
                                      setState(() => phoneNum = value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Phone Number",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                  )
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
