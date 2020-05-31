import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/screens/home/student_tile.dart';


class StudentList extends StatefulWidget{
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList>{

  @override
  Widget build(BuildContext context) {

    final students = Provider.of<List<NewUser>>(context);

    students.forEach((students){
      print(students.userName);
      print(students.gender);
      print(students.userType);
    });


    return ListView.builder(
        itemBuilder: (context, index){
          return StudentTile(user: students[index]);
        },
        itemCount: students.length);
  }
}