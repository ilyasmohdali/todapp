import 'dart:collection';
import 'dart:math';
import 'dart:async';

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
import 'package:rxdart/rxdart.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:tod_app/screens/home/StudentHome.dart';


class FireMap extends StatefulWidget {


  final markerLocation, userLocation, onTap;
  FireMap({this.markerLocation,this.userLocation,this.onTap});

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Location _location = Location();
  Set<Circle> circles = HashSet<Circle>();
  //RangeValues values = RangeValues(100,1000);
  final _formkey = GlobalKey<FormState>();
  Geoflutterfire geo = new Geoflutterfire();
  List<Marker> allMarkers = [];

  setMarker(){
    return allMarkers;
  }

  //double value;
  double radius2 =1000.0;
  int radii = 100;
  //static BehaviorSubject seedValue;

  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(1000.0);

  //ValueConnectableStream<double> radius = new ValueConnectableStream<double>(stream);
  Stream<dynamic> query;

  StreamSubscription subscription;
  List<DocumentSnapshot> documentList;

  Position _position;


  Position currentLocation;
  var tutors = [];
  String searchAddress;
  //Set<Marker> _marker = HashSet<Marker>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};


  _getCurrentLocation() async{
    var currentLocation = await Geolocator().getCurrentPosition();
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  LatLng _userLocation;

  bool mapToggle = false;
  var filterDist;

  Future<LocationData> _getUserLocation;
  Location location = new Location();

  LatLng initialPosition = LatLng(2.2262,102.4547);
  double value;

  @override
  void initState(){
    super.initState();
    _setCircles(mapController);
    _onMapCreated(mapController);
    _getCurrentLocation();
    //_startQuery();

    //placeFilteredMarker(data, distance, docID);
    //_updateQuery(value);
    //_updateMarkers(documentList);
    //dispose();
    Geolocator().getCurrentPosition().then((currLoc){
      setState(() {
        currentLocation = currLoc;
        mapToggle = true;
        setMarkers();
      });
    });

  }

  @override
  Widget build(BuildContext context) {


    return Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14.0
            ),
            //myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            circles: circles,
            markers: Set<Marker>.of(markers.values),
            myLocationEnabled: true,
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
                        hintText: 'Set Radius (Meter)',
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

                Slider(
                  min: 100,
                  max: 1000,
                  divisions: 9,
                  value: radius,
                  onChanged: (val)=> setState(() => radius = val),
                  label: "$radius",
                ),
                Text("Radius: $radius")
              ],
            ),
          ),
        )*/
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              height: 50.0,
              width: 250.0,
              child: RaisedButton(
                color: Colors.blue,
                child: Text("Set Radius", style: TextStyle(color: Colors.white),),
                onPressed: showRadiusSlider
              ),
            ),
          )
          /*Positioned(
          bottom: 50.0,
          child: FloatingActionButton(
            child: Icon(Icons.pin_drop, color: Colors.black),
            onPressed: _getLocation
          ),
        )*/
        ]);
  }


  void _onMapCreated(GoogleMapController controller) {
    //_startQuery();
    setState(() {
      /*_location.onLocationChanged.listen((l) {
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(l.latitude, l.longitude),
            zoom: 14.7
        )
        ));
      });*/
      mapController = controller;
    });
  }
  /*void _onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;
    });
  }*/


  /*searchAndNavigate() {
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
  }*/


  /*void _getLocation() async {
    var currentLocation = await Geolocator().getCurrentPosition();

    setState(() {
      markers.clear();
      final marker = Marker(
        markerId: MarkerId("current_location"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: "Current Location")
      );
      markers["Current Location"] = marker;
    });
  }*/



  void _setCircles(GoogleMapController controller) async{
    var currentLocation = await Geolocator().getCurrentPosition();
    setState(() {
    circles.add(
        Circle(
        circleId: CircleId("circle"),
        //center: _createCenter(),
        center: LatLng(currentLocation.latitude,currentLocation.longitude),
        radius: radius2,
        fillColor: Colors.blueAccent.withOpacity(0.1),
        strokeWidth: 1,
        strokeColor: Colors.blueAccent,
    ));
    });
  }


  showRadiusSlider(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
          height: 160.0,
          width: double.infinity,
          padding: EdgeInsets.only(left: 10.0,right: 10.0),

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
                      hintText: 'Set Radius (Meter)',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 22.0, top: 16.0),
                      /*suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: searchAndNavigate,
                        )*/),
                    /*onChanged: (val) {
                    setState(() {
                      filterDist = val;
                    });
                  },*/
                  ),
                ),

                Slider(
                      value: radius.value,
                      min: 1000,
                      max: 10000,
                      divisions: 9,
                      label: radius.value.toString(),
                      onChanged: _updateQuery
                    ),
                    Text("Radius: " + radius.value.toString()),
                /*Slider(
                  value: (radii ?? 100.0).toDouble(),
                  onChanged: (val){setState(()=> radii = val.round());},
                  min: 100.0,
                  max: 500.0,
                  divisions: 4,
                  label: '$radii',
                ),*/


                RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                      },
                      child: Text("Confirm", style: TextStyle(color: Colors.white)),
                    )
              ],
            ),
          );
    });
  }
  Firestore firestore = Firestore.instance;

  setMarkers(){
    firestore.collection('locations').getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        for(int i = 0; i<docs.documents.length; i++){
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(data,docID){
    var markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(data['LatLng'].latitude, data['LatLng'].longitude),
      infoWindow: InfoWindow(title: data['resultAddress'])
    );

    setState(() {
      markers[markerId] = marker;
    });
  }


  void _updateMarkers(List<DocumentSnapshot> documentList){
    String docID;
    var  markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);
    print(documentList);
    documentList.forEach((DocumentSnapshot document){
      GeoPoint pos = document.data['LatLng'];
      double distance = document.data['distance'];
      var marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude,pos.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'tutor location', snippet: '$distance metres from you')
      );
      setState(() {
        markers[markerId] = marker;
      });
    });
  }


  _startQuery() async {
     var pos = await _location.getLocation();
     var ref = Firestore.instance.collection('locations');
     GeoFirePoint center = geo.point(latitude: currentLocation.latitude, longitude: currentLocation.longitude);

     subscription = radius.switchMap((rad){
       return geo.collection(collectionRef: ref).within(
           center: center,
           radius: rad,
           field: 'position',
          strictMode: true
       );
     }).listen(_updateMarkers);
  }

  _updateQuery(value) {

    final zoomMap = {
      1000.0: 14.75,
      2000.0: 14.5,
      3000.0: 14.25,
      4000.0: 14.0,
      5000.0: 13.75,
      6000.0: 13.5,
      7000.0: 13.25,
      8000.0: 13.0,
      9000.0: 12.75,
      10000.0: 12.5,
    };

    final zoom = zoomMap[value];
    mapController.moveCamera(CameraUpdate.zoomTo(zoom));


    setState(() {
      radius.value = value;
    });
  }

  /*filterMarkers(dist){
    firestore.collection('locations').getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        for(int i = 0; i<docs.documents.length; i++){
          Geolocator().distanceBetween(initialPosition.latitude, initialPosition.longitude, docs.documents[i].data['LatLng'].latitude,
              docs.documents[i].data['LatLng'].longitude).then((calcDist){
                print(calcDist.toString());
                if(calcDist < dist)
                  {
                    placeFilteredMarker(docs.documents[i].data, calcDist.toDouble(), docs.documents[i].documentID);
                  }
          });
            //placeFilteredMarker(docs.documents[i].data, docs.documents[i].documentID, docs.documents[i].data['LatLng']);
        }
      }
    });
  }*/

  /*placeFilteredMarker(data, distance, docID){

    var markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(data['LatLng'].latitude, data['LatLng'].longitude),
        infoWindow: InfoWindow(title: data['resultAddress'], snippet: distance.toString())
    );

    setState(() {
      markers[markerId] = marker;
    });
  }*/


  /*Future<bool> getDist(){
    return showDialog(context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          title: Text('Enter Distance(metres'),
          contentPadding: EdgeInsets.all(10.0),
          content: TextField(
            decoration: InputDecoration(hintText: 'distance in metres'),
            onChanged: (val){
                setState(() => filterDist = val);
                setState(() => markers = {});
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              color: Colors.transparent,
              textColor: Colors.black,
              onPressed: (){
                filterMarkers(filterDist);
                Navigator.of((context)).pop();
        })
          ],
        );
      }
    );
  }*/




  @override
  void dispose() {
    // TODO: implement dispose
    //subscription.cancel();
    super.dispose();
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


}