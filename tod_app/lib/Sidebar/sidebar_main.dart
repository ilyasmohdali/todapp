import 'package:flutter/material.dart';
import 'package:tod_app/Sidebar/sidebar.dart';
import 'package:tod_app/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideBarMain extends StatefulWidget{
  const SideBarMain({
    Key key,
    @required this.user
  }
      ) :super(key:key);
  final FirebaseUser user;
  @override
  SideBarMainState createState() => new SideBarMainState();
}

class SideBarMainState extends State<SideBarMain> {
  @override
    Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Home(),
        Sidebar(),
      ],
    );
  }
}