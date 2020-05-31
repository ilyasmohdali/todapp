import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tod_app/models/NewUser.dart';

class UserNotifier with ChangeNotifier{
  List<NewUser> _userList = [];


  NewUser _currentUser;

  UnmodifiableListView<NewUser> get userList => UnmodifiableListView(_userList);

  NewUser get currentUser => _currentUser;

  set userList(List<NewUser> userList){
    _userList = userList;
    notifyListeners();
  }

  set currenUser(NewUser newUser){
    _currentUser = newUser;
    notifyListeners();
  }
}