import 'package:flutter/material.dart';


class AdminHome extends StatefulWidget{
  final String uid;
  AdminHome({this.uid});

  @override
  _AdminHomeState createState() => _AdminHomeState();

}

class _AdminHomeState extends State<AdminHome>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
    );
  }
}