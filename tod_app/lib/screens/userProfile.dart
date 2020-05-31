import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/screens/home/student_list.dart';


class UserProfile extends StatefulWidget{
  final String uid;
  UserProfile({this.uid});

  _UserProfileState createState() => new _UserProfileState();

}

class _UserProfileState extends State<UserProfile>{

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
              body: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 230.0,
                        color: Color(0xFF262AAA),
                      ),
                    Row(
                      children: <Widget>[
                      Container(
                      //alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 100.0, bottom: 10.0, left: 40.0),
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
                          width: 200.0,
                          margin: EdgeInsets.only(top: 90.0, left: 35.0),
                          child: RaisedButton(
                            onPressed: (){},
                            child: Text("Edit Profile", style: TextStyle(fontSize: 20.0, fontFamily: "Poppins", color: Colors.black)),
                        )
                        )])]
                )],
              ),
            );
          }
          else{
            return Loading();
          }
        });
  }
}