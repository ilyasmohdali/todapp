import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/notifier/usernotifier.dart';


class DatabaseService{
  //collection reference
  //FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final String uid;
  DatabaseService({this.uid});

  Future createUser(NewUser user) async {
    try{
      await userCollection.document(user.id).setData(user.toJson());
    }catch (e){
      return e.message;
    }
  }

  /*Future getCurrentUser()  async {
    return userCollection.where('uid' == uid).snapshots();
  }*/


  /*Future getCurrentUsers(UserNotifier userNotifier) async {
    QuerySnapshot snapshot = await userCollection.getDocuments();
    
    List<NewUser> _userList = [];
    
    snapshot.documents.forEach((document){
      NewUser newUser = NewUser.fromData(document.data);
      _userList.add(newUser);
    });

    userNotifier.userList = _userList;
  }*/

  NewUser _newUserDataFromSnapshot(DocumentSnapshot snapshot)
  {
    return NewUser(
      id : uid,
      userName : snapshot.data['userName'],
      email: snapshot.data['email'],
      gender: snapshot.data['gender'],
      userType: snapshot.data['userType'],
      phoneNum: snapshot.data['phoneNum'],
      imageURL: snapshot.data['imageURL'],
    );
  }

  Stream<NewUser> get userData{
    return userCollection.document(uid).snapshots().map(_newUserDataFromSnapshot);
  }


  /*Future updateStudentData(String userName, String gender, String age) async {

    return await userCollection.document(uid).setData({
      'userName' : userName,
      'gender' : gender,
      'age' : age
    });
  }

  //student list from snapshot
  List<NewUser> _studentListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return NewUser(
        userName: doc.data['userName'] ?? '',
        gender: doc.data['gender'] ?? '',
        age: doc.data['age'] ?? ''
      );
    }).toList();
  }

  Stream<List<NewUser>> get students{
    return userCollection.snapshots().map(_studentListFromSnapshot);
  }*/

/*
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

  getData() async {
    return await studentCollection.getDocuments();
  }

  updateData(){}*/

}