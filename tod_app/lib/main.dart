import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/screens/home.dart';
import 'package:tod_app/screens/wrapper.dart';
import './screens/login_screen.dart';
import 'package:tod_app/models/user.dart';


void main() => runApp(TODapp());

class TODapp extends StatefulWidget{
  @override
  _TODappState createState() => new _TODappState();
}

class _TODappState extends State<TODapp>{
  //root
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthenticationService().user,
        child: MaterialApp(
          title: "TutorOnDemand",
          debugShowCheckedModeBanner: false,
          home: Wrapper()
    ));
  }
}