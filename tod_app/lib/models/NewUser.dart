class NewUser{

  final String id;
  final String userName;
  final String email;
  final String gender;
  final String userType;
  final String phoneNum;
  final String imageURL;

  NewUser({this.id, this.userName, this.email, this.gender, this.userType, this.phoneNum, this.imageURL});

  NewUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
    userName = data['name'],
    email = data['email'],
    phoneNum = data['phoneNum'],
    gender = data['gender'],
    userType = data['userType'],
    imageURL = data['imageURL'];

  Map<String, dynamic> toJson(){
   return{
     'uid' : id,
     'userName' : userName,
     'email' : email,
     'phoneNum' : phoneNum,
     'gender' : gender,
     'userType' : userType,
     'imageURL' : imageURL
   };
  }
}