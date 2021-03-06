//import 'dart:js';

import 'dart:collection';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tod_app/Sidebar/StudentDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tod_app/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:tod_app/Map/map.dart';


class StudentHome extends StatefulWidget{
  final String uid;
  final Function searchAndNavigate;
  StudentHome({this.uid,this.searchAndNavigate});
  @override
  _StudentHomeState createState() => _StudentHomeState();
}


class _StudentHomeState extends State<StudentHome> {

  String searchAddress;
  GoogleMapController mapController;

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        border: InputBorder.none,
      ));
  AppBar cusAppBar = AppBar(
      backgroundColor: Color(0x44000000).withOpacity(0.0),
      iconTheme: IconThemeData(
        color: Colors.black,
      ));

  FirebaseUser user;
/*
  void setUser(FirebaseUser user){
    setState(() {
      this.user = user;
    });
  }

  @override
  void initState(){
    super.initState();
    FirebaseAuth.instance.currentUser().then(setUser);
  }*/


  /*GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }*/

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0x44000000).withOpacity(0.0),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0.0,
        ),
        drawer: StudentDrawer(),
        body: FireMap(),
      );
  }
}











