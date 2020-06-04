import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/notifier/usernotifier.dart';


class DatabaseService{
  //collection reference
  //FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final String uid;
  final String userName;
  final File file;
  final String email; final String gender; String userType; String phoneNum; String imageUrl;
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://todapp4real.appspot.com');
  DatabaseService({this.uid, this.userName,this.email, this.gender, this.userType, this.phoneNum, this.imageUrl, this.file});

  Future createUser(NewUser user) async {
    try{
      await userCollection.document(user.id).setData(user.toJson());
    }catch (e){
      return e.message;
    }
  }

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

  Future updateStudentData(String uid, String userName, String email, String gender, String userType, String phoneNum, String imageUrl) async {

    return await userCollection.document(uid).setData({
      'uid' : uid,
      'userName' : userName,
      'email' : email,
      'gender' : gender,
      'userType' : userType,
      'phoneNum' : phoneNum,
      'imageURL' : imageUrl,
    });
  }



  uploadImage(String uid, String userName, String email, String gender, String userType, String phoneNum, String imageUrl) async {
    String filePath = 'profiles/${DateTime.now()}.jpg' ;
    StorageUploadTask task = _storage.ref().child(filePath).putFile(file);

    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    var imageUrl = downUrl.toString();
    updateImageURL(uid, userName, email, gender, userType, phoneNum, imageUrl);
    print('Download URL :  $imageUrl');

    return imageUrl;
  }

  Future updateImageURL(String uid, String userName, String email, String gender, String userType, String phoneNum, String imageUrl) async {
    return await userCollection.document(uid).setData({
      'uid' : uid,
      'userName' : userName,
      'email' : email,
      'gender' : gender,
      'userType' : userType,
      'phoneNum' : phoneNum,
      'imageURL' : imageUrl.toString(),
    });
  }

  //student list from snapshot
  /*List<NewUser> _studentListFromSnapshot(QuerySnapshot snapshot){
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