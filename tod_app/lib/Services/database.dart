import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/models/UserLocation.dart';
import 'package:tod_app/notifier/usernotifier.dart';
import 'package:geoflutterfire/geoflutterfire.dart';


class DatabaseService{
  //collection reference
  //FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference locationCollection = Firestore.instance.collection('locations');
  final String uid;
  final String userName;
  final File file;
  final String tutorTeach1; String tutorTeach2; String tutorTeach3; String verified;
  final String email; final String gender; String userType; String phoneNum; String imageUrl; String userPreference1; String userPreference2; String userPreference3;
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://todapp4real.appspot.com');
  Geoflutterfire geo = Geoflutterfire();
  DatabaseService({this.uid, this.userName,this.email, this.gender, this.userType, this.phoneNum, this.imageUrl,
    this.file, this.userPreference1, this.userPreference2, this.userPreference3, this.tutorTeach1, this.tutorTeach2, this.tutorTeach3, this.verified});

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
      userPreference1: snapshot.data['userPreference1'],
      userPreference2: snapshot.data['userPreference2'],
      userPreference3: snapshot.data['userPreference3'],
      tutorTeach1: snapshot.data['tutorTeach1'],
      tutorTeach2: snapshot.data['tutorTeach2'],
      tutorTeach3: snapshot.data['tutorTeach3'],
      verified: snapshot.data['verified']
    );
  }

  UserLocation _newLocationDataFromSnapshot(DocumentSnapshot snapshot)
  {
    return UserLocation(
      docId: snapshot.data['docID'],
      uid: snapshot.data['id'],
      LatLng: snapshot.data['LatLng'],
      address: snapshot.data['resultAddress']
    );
  }

    Stream<NewUser> get userData{
    return userCollection.document(uid).snapshots().map(_newUserDataFromSnapshot);
  }

  Stream<UserLocation> get locationData{
    return locationCollection.document(uid).snapshots().map(_newLocationDataFromSnapshot);
  }

  Future updateStudentData(String uid, String userName, String email, String gender, String userType, String phoneNum, String imageUrl, String userPreference1, String userPreference2, String userPreference3, String tutorTeach1, String tutorTeach2, String tutorTeach3, String verified) async {
    return await userCollection.document(uid).setData({
      'uid' : uid,
      'userName' : userName,
      'email' : email,
      'gender' : gender,
      'userType' : userType,
      'phoneNum' : phoneNum,
      'imageURL' : imageUrl,
      'userPreference1' : userPreference1,
      'userPreference2' : userPreference2,
      'userPreference3' : userPreference3,
      'tutorTeach1' : tutorTeach1,
      'tutorTeach2' : tutorTeach2,
      'tutorTeach3' : tutorTeach3,
      'verified' : verified
    });
  }

  uploadImage(String uid, String userName, String email, String gender, String userType, String phoneNum, String imageUrl, String userPreference1, String userPreference2, String userPreference3, String tutorTeach1, String tutorTeach2, String tutorTeach3, String verified) async {
    String filePath = 'profiles/${DateTime.now()}.jpg' ;
    StorageUploadTask task = _storage.ref().child(filePath).putFile(file);

    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    var imageUrl = downUrl.toString();
    updateImageURL(uid, userName, email, gender, userType, phoneNum, imageUrl, userPreference1, userPreference2, userPreference3,tutorTeach1,tutorTeach2,tutorTeach3, verified);
    print('Download URL :  $imageUrl');

    return imageUrl;
  }

  Future updateImageURL(String uid, String userName, String email, String gender, String userType, String phoneNum, String imageUrl, String userPreference1, String userPreference2, String userPreference3,String tutorTeach1, String tutorTeach2, String tutorTeach3, String verified) async {
    return await userCollection.document(uid).setData({
      'uid' : uid,
      'userName' : userName,
      'email' : email,
      'gender' : gender,
      'userType' : userType,
      'phoneNum' : phoneNum,
      'imageURL' : imageUrl.toString(),
      'userPreference1' : userPreference1,
      'userPreference2' : userPreference2,
      'userPreference3' : userPreference3,
      'tutorTeach1' : tutorTeach1,
      'tutorTeach2' : tutorTeach2,
      'tutorTeach3' : tutorTeach3,
      'verified' : verified,
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