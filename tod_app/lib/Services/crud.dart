
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUD {

  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference studentCollection = Firestore.instance.collection('students');

  bool isLoggedIn(){
    if(_auth.currentUser() != null){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> addData(studentData) async {
    if(isLoggedIn()){
      studentCollection.add(studentData).catchError((e){
        print(e);
      });
    }
    else{
      print('Log In Required');
    }
  }
}