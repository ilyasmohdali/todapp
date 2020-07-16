import 'package:cloud_firestore/cloud_firestore.dart';

class NewUser{

  final String id;
  final String userName;
  final String email;
  final String gender;
  final String userType;
  final String phoneNum;
  final String imageURL;
  final String userPreference1;
  final String userPreference2;
  final String userPreference3;
  final String tutorTeach1;
  final String tutorTeach2;
  final String tutorTeach3;
  final String verified;

  NewUser({this.id, this.userName, this.email, this.gender, this.userType, this.phoneNum, this.imageURL,
    this.userPreference1,this.userPreference2,this.userPreference3, this.tutorTeach1, this.tutorTeach2,this.tutorTeach3, this.verified});

  NewUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
    userName = data['name'],
    email = data['email'],
    phoneNum = data['phoneNum'],
    gender = data['gender'],
    userType = data['userType'],
    imageURL = data['imageURL'],
    userPreference1 = data['userPreference1'],
    userPreference2 = data['userPreference1'],
    userPreference3 = data['userPreference1'],
    tutorTeach1 = data['tutorTeach1'],
    tutorTeach2 = data['tutorTeach2'],
    tutorTeach3 = data['tutorTeach3'],
    verified = data['verified'];

  //List<DocumentSnapshot> get documents => documents;



  Map<String, dynamic> toJson(){
   return{
     'uid' : id,
     'userName' : userName,
     'email' : email,
     'phoneNum' : phoneNum,
     'gender' : gender,
     'userType' : userType,
     'imageURL' : imageURL,
     'userPreference1' : userPreference1,
     'userPreference2' : userPreference2,
     'userPreference3' : userPreference3,
     'tutorTeach1' : tutorTeach1,
     'tutorTeach2' : tutorTeach2,
     'tutorTeach3' : tutorTeach3,
     'verified' : verified
   };
  }
}