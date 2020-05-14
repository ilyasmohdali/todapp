import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tod_app/Widgets/MainDrawer.dart';


class Home extends StatefulWidget{
  const Home({
    Key key,
    @required this.user
  }
      ) :super(key:key);
  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
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
      drawer: MainDrawer(),
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