import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/user.dart';
import 'package:tod_app/notifier/usernotifier.dart';


void main() => runApp(
  MultiProvider(providers: [
    ChangeNotifierProvider(
      builder:(context)=> UserNotifier(),
  ),],
    child:TODapp(),
));

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