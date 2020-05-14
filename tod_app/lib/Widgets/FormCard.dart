import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/Sidebar/sidebar_main.dart';
import 'package:tod_app/screens/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tod_app/screens/home.dart';


class FormCard extends StatefulWidget{
  final Function toggleView;
  FormCard({this.toggleView});

  @override
  FormCardState createState() => new FormCardState();
}

class FormCardState extends State<FormCard>{
  final AuthenticationService _auth = AuthenticationService();

  //text field state
  String email = '' , password = '' , error ='';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return new Column(
      children: <Widget>[
        Container(
            width: double.infinity,
            //height: ScreenUtil().setHeight(500),
             height: 360.0,
              margin: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.0,15.0),
                  blurRadius: 30.0),
                ]),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Login", style: TextStyle(
                    fontSize: 45.0,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    letterSpacing: .6
                  )),
                SizedBox(
                height: 5.0,
                ),
                  Text("Email", style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 26.0,
                  //fontSize: ScreenUtil().setSp(26),
                )),
                TextFormField(
                  validator: (value) => value.isEmpty ? 'Enter an Email' : null,
                  onChanged: (value){
                    setState(() => email = value);
                  },
                  //onSaved: (emailInput) => email = emailInput,
                  decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                ),
                ),
                SizedBox(
                  height: 5.0
                ),
                Padding(padding: EdgeInsets.only(top: 10.0),),
                Text("Password",
                  style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 26.0,
                //fontSize: ScreenUtil().setSp(26)
                )),
                TextFormField(
                  validator: (value) => value.length < 5 ? 'Enter password 5+ character long' : null,
                  onChanged: (value){
                    setState(() => password = value);
                  },
                  obscureText: true,
                  //onSaved: (passwordInput) => password = passwordInput,
                  decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                  ),
               ),
                /*SizedBox(
                 height: ScreenUtil().setHeight(35),
                 ),*/
                 Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 35.0)),
                    Text(
                  "Doesnt have account? ",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontSize: 15.0,
                    //fontSize: ScreenUtil().setSp(28)
                  ),
                ),
                  FlatButton(
                  onPressed: () {widget.toggleView();},
                  child:Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: "Poppins",
                    fontSize: 15.0,
                    //fontSize: ScreenUtil().setSp(28)
                  )),
                )
              ],
            ),
          ],
        ),
      ),),
    ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
                child: Container(
                  margin: EdgeInsets.only(
                      top: 20.0, bottom: 20.0),
                  width: 175.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFF17ead9),
                        Color(0xFF6078ed)
                      ]),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            offset: Offset(0.0, 9.0),
                            blurRadius: 8.0
                        )
                      ]),
                  child: Material(
                    color: Colors.transparent,
                    child: FlatButton(
                      color: Color.fromARGB(0, 0, 0, 0),
                      onPressed: () async {
                        if (_formKey.currentState.validate()){
                          dynamic result = await _auth.signInWithEmailandPassword(email, password);
                          if (result == null){
                            setState(() => error = 'please supply a valid email');
                          }
                        }
                      },
                      child: Center(
                        child: Text("LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                                letterSpacing: 1.0
                            )),
                      ),
                    ),
                  ),
                )
            )
          ],
        ),]);
  }
}