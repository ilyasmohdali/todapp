import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tod_app/Sidebar/TutorDrawer.dart';

class TutorHome extends StatefulWidget{
  final String uid;
  TutorHome({this.uid});

  @override
  _TutorHomeState createState() => _TutorHomeState();

}

class _TutorHomeState extends State<TutorHome>{

  FirebaseUser user;


  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFFbee8f9),
        appBar: AppBar(
          backgroundColor: Color(0x44000000).withOpacity(0.0),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0.0,
        ),
        drawer: TutorDrawer(),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        )
    );
  }
}