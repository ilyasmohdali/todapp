import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/screens/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tod_app/screens/SignUpPage.dart';


class SignUpForm extends StatefulWidget{
  final Function toggleView;
  SignUpForm({this.toggleView});

  @override
  SignUpFormState createState() => new SignUpFormState();
}


class SignUpFormState extends State<SignUpForm>{
  final AuthenticationService _auth = AuthenticationService();
  String email = '', password ='' , error = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return new Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            //height: ScreenUtil().setHeight(500),
            height: 360.0,
            margin: EdgeInsets.only(top: 5.0),
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
                    Text("Sign Up", style: TextStyle(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 35.0)),
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
                            fontSize: 15.0,
                            //fontSize: ScreenUtil().setSp(28)
                          ),
                        ),
                        InkWell(
                          onTap: () {widget.toggleView();},
                          child:Text(
                              "Login",
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
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
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
                            dynamic result = await _auth.registerWithEmailandPassword(email, password);
                            if (result == null){
                              setState(() => error = 'please supply a valid email');
                            }
                          }
                        },
                        child: Center(
                          child: Text("SIGN UP",
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
              ),
            ],
          ),]);
  }
}