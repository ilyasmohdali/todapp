import 'package:flutter/material.dart';
import 'package:tod_app/models/NewUser.dart';


class StudentTile extends StatelessWidget{

  final NewUser user;
  StudentTile ({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.blue,
          ),
          title: Text(user.userName),
        ),
      ),
    );
  }
}