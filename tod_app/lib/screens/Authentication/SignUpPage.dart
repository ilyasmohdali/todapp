
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tod_app/Widgets/loading.dart';
import 'package:tod_app/Services/authentication_services.dart';
import 'package:tod_app/screens/Authentication/login_screen.dart';


class SignUpPage extends StatefulWidget{
  final Function toggleView;
  SignUpPage({this.toggleView});
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{

  final AuthenticationService _auth = AuthenticationService();

  //text field state
  String email = '';
  String password = '';
  String userName = '';
  String phoneNum = '';
  String gender = '';
  String userType = '';
  String error = '';
  String _selectedType;
  String _selectedGender;
  List <String> genderList = <String> ['Male','Female'];
  List <String> uType = <String> ['Student','Tutor'];

  bool _obscureText = true;




  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }




  /*DateTime selectedDate =DateTime.now();


  TextEditingController _date = new TextEditingController();

  Future _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year -70),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(text: DateFormat('dd-MM-yyyy').format(picked).toString());
      });
  }*/


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return  loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFFbee8f9),
      resizeToAvoidBottomPadding: true,

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(28.0, 30.0, 28.0, 40.0),
          child: Column(
            children: <Widget>[
              /*Container(
                height: 160.0,
                width: 220.0,
                 //padding: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0.0,15.0),
                        blurRadius: (20.0)
                      )
                    ]
                  ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Image.asset("assets/images/tod.png",
                        width: 200.0, height: 120.0)),
                        Expanded(
                        //margin: EdgeInsets.only(bottom: 10.0),
                          child:Container(
                            height: 30.0,
                            margin: EdgeInsets.only(bottom: 0.0),
                            //padding: EdgeInsets.only(bottom: ),
                            child:Text("Tutor On Demand", style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.w700
                            )
                            )
                          )
                        )
                  ])
              ),*/
              Container(
                width: double.infinity,
                //height: ScreenUtil().setHeight(500),

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
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Sign Up", style: TextStyle(
                            fontSize: 40.0,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            letterSpacing: .6
                        )),
                        Text("Username", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22.0,
                          //fontSize: ScreenUtil().setSp(26),
                        )),
                        TextFormField(
                          validator: (value) => value.isEmpty ? 'Enter a Username' : null,
                          onChanged: (value){
                            setState(() => userName = value);
                          },
                          //onSaved: (emailInput) => email = emailInput,
                          decoration: InputDecoration(
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                          ),
                          maxLength: 15,
                        ),
                        SizedBox(height: 5.0,),
                        Text("Email", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22.0,
                          //fontSize: ScreenUtil().setSp(26),
                        )),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
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
                        SizedBox(height: 5.0,),
                        Text("Phone Number", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22.0,
                          //fontSize: ScreenUtil().setSp(26),
                        )),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) => value.isEmpty ? 'Enter your Phone Number' : null,
                          onChanged: (value){
                            setState(() => phoneNum = value);
                          },
                          //onSaved: (emailInput) => email = emailInput,
                          decoration: InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)
                          ),
                        ),
                        SizedBox(
                            height: 5.0
                        ),
                        Text("Gender", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22.0,
                          //fontSize: ScreenUtil().setSp(26),
                        )),
                        DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Choose your gender', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.0)),
                          validator: (value) => value==null ? 'Choose your Gender' : null,
                          value: _selectedGender,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue;
                              gender = _selectedGender;
                            });
                          },
                          items: genderList.map((gender) {
                            return DropdownMenuItem(
                              child: new Text(gender),
                              value: gender,
                            );
                          }).toList(),
                        ),
                        SizedBox(
                            height: 5.0
                        ),
                        Text("Sign Up As", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 22.0,
                          //fontSize: ScreenUtil().setSp(26),
                        )),
                        DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Signing Up As', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.0)),
                          validator: (value) => value == null ? 'What would you like to sign up as?' : null,
                          value: _selectedType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedType = newValue;
                              userType = _selectedType;
                            });
                          },
                          items: uType.map((userType) {
                            return DropdownMenuItem(
                              child: new Text(userType),
                              value: userType,
                            );
                          }).toList(),
                        ),
                          Text("Password",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 22.0,
                              //fontSize: ScreenUtil().setSp(26)
                            )),
                          TextFormField(
                          validator: (value) => value.length < 5 ? 'Enter password 5+ character long' : null,
                          onChanged: (value){
                            setState(() => password = value);
                          },
                          obscureText: _obscureText,
                          //onSaved: (passwordInput) => password = passwordInput,
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                              suffix : InkWell(onTap: _toggle, child: Text(_obscureText ? "Show" : "Hide")),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 30.0)),
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
                                          setState(() => loading = true);
                                          dynamic result = await _auth.registerWithEmailandPassword(userName, email, phoneNum, gender, userType, password);
                                          if (result == null){
                                            setState(() {
                                              error = 'Error logging in';
                                              loading = false;
                                            });
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
          ]),
        ),
      )
    );
  }
}