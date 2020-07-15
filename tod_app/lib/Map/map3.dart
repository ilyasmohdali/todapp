import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class FireMap3 extends StatefulWidget {

  final markerLocation, userLocation, onTap;
  final Function searchAndNavigate;
  final String userid;

  const FireMap3({Key key, this.userid, this.markerLocation, this.userLocation, this.onTap, this.searchAndNavigate}):super (key:key);

  @override
  _FireMap3State createState() => _FireMap3State();
}

class _FireMap3State extends State<FireMap3> {
  GoogleMapController mapController;
  Location _location = Location();
  //Set<Circle> circles = HashSet<Circle>();
  Future<LocationData> _getUserLocation;

  LatLng _markerLocation;
  LatLng _userLocation;
  String _resultAddress;

  //RangeValues values = RangeValues(100,1000);

  double radius =100;


  LatLng _initialPosition = LatLng(2.3113, 102.4309);
  String searchAddress;
  Set<Marker> _marker = HashSet<Marker>();


  //final Map<String, Marker> _markers = {};

  @override
  void initState(){
    super.initState();
    //_setCircles(mapController);
    //_onMapCreated(mapController);
    //_getUserLocation = getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: widget.userLocation,
                zoom: 15.0
            ),
            //myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            mapType: MapType.normal,
            markers: widget.markerLocation != null ? [
              Marker(
                  markerId: MarkerId("Tap Location"),
                position:  widget.markerLocation)].toSet() : null, onTap: widget.onTap,
          ),
          /*Positioned(
          top: 27.0,
          right: 5.0,
          left: 5.0,
          child: Container(
            //padding: EdgeInsets.only(left: 40.0),
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white
            ),
            child: TextField(
              decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 50.0, top: 16.0),
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
              onPressed: searchAndNavigate,
             )), onChanged: (val) {
                setState(() {
                  searchAddress = val;
                });
              },
            ),
        )),*/

          /*Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              height: 180.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    //padding: EdgeInsets.only(left: 40.0),
                    height: 45.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Set Home (place marker on location)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 22.0, top: 16.0),
                        /*suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: searchAndNavigate,
                        )*/),
                      /*onChanged: (val) {
                    setState(() {
                      searchAddress = val;
                    });
                  },*/
                    ),
                  ),
                  Text("Home"),
                  FloatingActionButton()
                ],
              ),
            ),
          )*/
          /*Positioned(
          bottom: 50.0,
          child: FloatingActionButton(
            child: Icon(Icons.pin_drop, color: Colors.black),
            onPressed: _getLocation
          ),
        )*/
        ]);
  }


  /*void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _location.onLocationChanged.listen((l) {
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(l.latitude, l.longitude),
            zoom: 15.0
        )
        ));
      });
    });
  }*/

  void onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;
    });
  }


  searchAndNavigate() {
    setState(() {
      Geolocator().placemarkFromAddress(searchAddress).then((result) {
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(
                    result[0].position.longitude, result[0].position.longitude),
                zoom: 10.0
            )));
      });
    });
  }

  /*void _getLocation() async {
    var currentLocation = await Geolocator().getCurrentPosition();

    setState(() {
      _markers.clear();
      final marker = Marker(
          markerId: MarkerId("current_location"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: "Current Location")
      );
      _markers["Current Location"] = marker;
    });
  }*/

  /*void _setCircles(GoogleMapController controller) async{
    var currentLocation = await Geolocator().getCurrentPosition();
    setState(() {

      circles.add(
          Circle(
              circleId: CircleId("circle"),
              //center: _createCenter(),
              center: LatLng(currentLocation.latitude,currentLocation.longitude),
              radius: 500.0,
              fillColor: Colors.blueAccent.withOpacity(0.1),
              strokeWidth: 1,
              strokeColor: Colors.blueAccent
          ));
    });
  }*/


}