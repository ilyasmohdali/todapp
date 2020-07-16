import 'package:firebase_auth/firebase_auth.dart';
import 'package:tod_app/Services/database.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/models/user.dart';


class AuthenticationService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  NewUser _newUser;
  NewUser get currentUser => _newUser;
  //String imageURL = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQsKNbGtuXiKKlaS0oDJ72NksP7CS-tl7YInR67NXNTgfvTfkXk&usqp=CAU';
  String imageURL = 'https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg';

  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in anonymously
  Future signInAnonymously() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailandPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch (e){
      print(e.toString());
    }
  }

  //register with email & password
  Future registerWithEmailandPassword(String userName, String email, String phoneNum, String gender, String userType, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser  user = result.user;

      _newUser = NewUser(
        id : user.uid,
        userName: userName,
        email: email,
        phoneNum : phoneNum,
        gender: gender,
        userType: userType,
        imageURL: imageURL,
        userPreference1: "",
        userPreference2: "",
        userPreference3: "",
        tutorTeach1: "",
        tutorTeach2: "",
        tutorTeach3: "",
        verified: "No"
      );

      await DatabaseService().createUser(_newUser);

      return _userFromFirebaseUser(user);
    }
    catch(e){
      print (e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}

