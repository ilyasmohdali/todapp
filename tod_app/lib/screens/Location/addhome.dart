import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tod_app/Map/map.dart';
import 'package:tod_app/Map/map3.dart';
import 'package:tod_app/Sidebar/TutorDrawer.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/models/user.dart';

class AddHome extends StatefulWidget{
  final String uid;
  final Function searchAndNavigate;
  AddHome({this.uid,this.searchAndNavigate});

  @override
  _AddHomeState createState() => _AddHomeState();

}

class _AddHomeState extends State<AddHome>{

  //FirebaseUser user;
  //Geoflutterfire geo = new Geoflutterfire();

  Future<LocationData> _getUserLocation;
  Location location = new Location();

  String searchAddress;
  LatLng _markerLocation;
  LatLng _userLocation;
  String _resultAddress;


  Widget cusSearchBar = TextFormField(
    textInputAction: TextInputAction.go,
      style: TextStyle(
          fontFamily: "Poppins",
          color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search", hintStyle: TextStyle(color: Colors.white, fontFamily: "Poppins", fontSize: 18.0),
  ),
  );

  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _getUserLocation = getUserLocation();
  }



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0x44000000),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: cusSearchBar,
        actions: <Widget>[
          IconButton(
            onPressed: widget.searchAndNavigate,
            icon: Icon(Icons.search))
        ]
        ),
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child:
                FutureBuilder<LocationData>(
                  future: _getUserLocation,
                  builder: (context,snapshot){
                    switch(snapshot.hasData){
                      case true:
                        return FireMap3(
                          markerLocation: _markerLocation,
                          userLocation: _userLocation,
                          onTap: (location){
                            setState(() {
                              _markerLocation = location;
                            });
                          },
                        );
                      default: return Center();
                    }
                  },
                ),
              ),

              Text(
                _resultAddress ?? " Place Marker on the map", style: TextStyle(fontFamily: "Poppins", fontSize: 15.0),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(child: Text("Get My Location Address"),
                    onPressed: () async {if(_userLocation != null){
                      getSetAddress(Coordinates(_userLocation.latitude,_userLocation.longitude));}
                    }),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(child: Text("Get Marker Address"),
                    onPressed: () async {if(_markerLocation != null){
                      getSetAddress(Coordinates(_markerLocation.latitude,_markerLocation.longitude));}
                    }),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text("Save Location", style: TextStyle(color: Colors.white),),
                  onPressed: _addGeopoint,
                ),
              ),
            ],
          )
      ),
    );
  }



  Future<LocationData> getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.requestService();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return null;
      }
    }
    final result =  await location.getLocation();
    _userLocation = LatLng(result.latitude, result.longitude);
    return result;
  }

  getSetAddress(Coordinates coordinates) async {
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _resultAddress = addresses.first.addressLine;
    });
  }

  searchAndNavigate() async {

      Geolocator().placemarkFromAddress(searchAddress).then((result) {
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(
                    result[0].position.longitude, result[0].position.longitude),
                zoom: 10.0
            )));
      });
  }

  Future _addGeopoint() async{
    final user = Provider.of<User>(context);
    //FirebaseUser user;
    DocumentReference documentReference = Firestore.instance.collection('locations').document();
    documentReference.setData({
      "id" : user.uid,
      "docID" : documentReference.documentID,
      "resultAddress" : _resultAddress,
      "LatLng" : new GeoPoint(_markerLocation.latitude, _markerLocation.longitude)
    }).whenComplete((){
      Navigator.of(context).pop();
    });
  }

}

