import 'dart:collection';
import 'dart:math';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tod_app/Sidebar/StudentDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tod_app/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:tod_app/Widgets/wrapper.dart';
import 'package:tod_app/models/User.dart';
import 'package:tod_app/models/NewUser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:tod_app/screens/home/StudentHome.dart';
import 'package:tod_app/Widgets/loading.dart';


class FireMap extends StatefulWidget {


  final uid, markerLocation, userLocation, onTap;
  FireMap({this.uid,this.markerLocation,this.userLocation,this.onTap});

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Location _location = Location();
  Set<Circle> circles = HashSet<Circle>();
  //RangeValues values = RangeValues(100,1000);
  final _formkey = GlobalKey<FormState>();
  Geoflutterfire geo = Geoflutterfire();
  //List<Marker> allMarkers = [];

  /*setMarker(){
    return allMarkers;
  }*/


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
  var tutors =[];
  String searchAddress;
  //Set<Marker> _marker = HashSet<Marker>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};


  _getCurrentLocation() async{
    var currentLocation = await Geolocator().getCurrentPosition();
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  LatLng _userLocation;

  bool mapToggle = false;
  bool tutorsToggle = false;
  var filterDist;
  var radius3;

  Future<LocationData> _getUserLocation;
  Location location = new Location();

  LatLng initialPosition = LatLng(2.2262,102.4547);
  double value;

  //var data, distance, docID;
  @override
  void initState(){
    super.initState();
    //_setCircles(mapController);
    //_onMapCreated(mapController);
    _getCurrentLocation();
    //filterMarkers(dist);


    //getDist();
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
  Distance dist;

  @override
  Widget build(BuildContext context) {
//setMarkers();
    //setState(() {
      _setCircles(mapController);
      //filterMarkers(dist);
      //setMarkers();
      //_onMapCreated(mapController);
      //_startQuery();
    //});
    //_startQuery();
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
                //onPressed: getDist,
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
    _startQuery();
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
        radius: radius.value,
        //radius: radius3,
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
                      onPressed: (){
                        Navigator.pop(context);
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
    tutors = [];
    firestore.collection('locations').getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        setState(() {
          tutorsToggle = true;
        });
        for(int i = 0; i<docs.documents.length; i++){
          tutors.add(docs.documents[i].data);
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(data,docID){
    //final user = Provider.of<User>(context);
    var markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(data['LatLng'].latitude, data['LatLng'].longitude),
      infoWindow: InfoWindow(title: data['resultAddress']),
      onTap: (){
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0)
        )
        ),
            context: context,
            builder: (builder){
              return StreamBuilder(
                stream: firestore.collection('locations').document(docID).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Wrapper();
                  }
                  return new Container(
                    height: 270.0,
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(20.0, 3, 30.0, 5.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: StreamBuilder(
                              stream: firestore.collection('users').where('uid', isEqualTo: snapshot.data['id']).snapshots(),
                              builder: (context,snapshot){
                                if (!snapshot.hasData){
                                  return Wrapper();
                                }
                                final List<DocumentSnapshot> document = snapshot.data.documents;
                                return ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: document.length,
                                    itemBuilder:(context, index){
                                      /*return Card(
                                        child: ListTile(
                                          title: Text(document[index].data['userName']),
                                        ),
                                      );*/
                                      return Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10.0, top: 15.0),
                                            alignment: Alignment.centerLeft,
                                            child: Text("Tutor Details", style: TextStyle(fontFamily: "Poppins", fontSize: 20.0)),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                margin: EdgeInsets.only(bottom: 10.0, left: 15.0),
                                                width: 75.0,
                                                height: 75.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey,
                                                  image: DecorationImage(
                                                    //image: AssetImage('assets/images/tod_logo.PNG')
                                                      image: NetworkImage(document[index].data['imageURL'])
                                                    //image: NetworkImage(userNotifier.userList)
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width: 200.0,
                                                height: 90.0,
                                                margin: EdgeInsets.only(left: 20.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(document[index].data['email'], style: TextStyle(fontFamily: "Poppins", fontSize: 16.0),),
                                                    ),
                                                    SizedBox(height: 5.0,),
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(document[index].data['phoneNum'], style: TextStyle(fontFamily: "Poppins", fontSize: 16.0),),
                                                    ),
                                                    SizedBox(height: 5.0,),
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(document[index].data['gender'], style: TextStyle(fontFamily: "Poppins", fontSize: 16.0),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 5.0),
                            child: Text("Address", style: TextStyle(fontFamily: "Poppins", fontSize: 20.0)),
                          ),
                          Container(
                            child: Text(snapshot.data['resultAddress'], style: TextStyle(fontSize: 14.0, fontFamily: "Poppins"),),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
        );}
    );

    setState(() {
      markers[markerId] = marker;
    });
  }


  void _updateMarkers(List<DocumentSnapshot> documentList){
    String docID;
    var  markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);
    print('hello');
    print(documentList);
    markers.clear();
    documentList.forEach((DocumentSnapshot document){
      GeoPoint pos = document.data["position"]['geopoint'];
      double distance = document.data['distance'];
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude,pos.longitude),
        //icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'tutor location', snippet: '$distance kilometres from you'),
        //onTap: (){showModalBottomSheet(context: null, builder: null);}
      );
      /*setState(() {
        markers[markerId] = marker;
      });*/
    });
  }


  _startQuery() async {
     var pos = await _location.getLocation();
     var ref = Firestore.instance.collection('locations');
     GeoFirePoint center = geo.point(latitude: pos.latitude, longitude: pos.longitude);

     print(LatLng(center.latitude,center.longitude));
     subscription = radius.switchMap((rad){
       return geo.collection(collectionRef: ref).within(
           center: center,
           radius: rad,
           field: "position",
          strictMode: true
       );
     }).listen(_updateMarkers);
  }

  _updateQuery(value) {

    final zoomMap = {
      1000.0: 14.75,
      2000.0: 14.25,
      3000.0: 13.75,
      4000.0: 13.25,
      5000.0: 12.75,
      6000.0: 12.25,
      7000.0: 11.75,
      8000.0: 11.25,
      9000.0: 10.75,
      10000.0: 10.25,
    };

    final zoom = zoomMap[value];
    mapController.moveCamera(CameraUpdate.zoomTo(zoom));


    setState(() {
      //radius.add(value);
      radius.value = value;
    });
  }

  filterMarkers(dist){
    markers.clear();
    //firestore.collection('locations').getDocuments().then((docs){
      //if(docs.documents.isNotEmpty){
        for(int i = 0; i<tutors.length; i++){
          Geolocator().distanceBetween(initialPosition.latitude, initialPosition.longitude, tutors[i]['LatLng'].latitude,
              tutors[i]['LatLng'].longitude).then((calcDist){
                print(calcDist/1000);
                if(calcDist/1000 < dist)
                  {
                    placeFilteredMarker(tutors[i], tutors[i]['docID'], calcDist/1000);
                  }
          });
            //placeFilteredMarker(docs.documents[i].data, docs.documents[i].documentID, docs.documents[i].data['LatLng']);
        //}
     // }
    }
  }

  placeFilteredMarker(data, docID, distance){

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


  Future<bool> getDist(){
    return showDialog(context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          title: Text('Enter Distance(metres'),
          contentPadding: EdgeInsets.all(10.0),
          content: TextField(
            decoration: InputDecoration(hintText: 'distance in metres'),
            onChanged: (val){

              setState(() {
                filterDist = val;
              });

            },
          ),
          actions: <Widget>[
            FlatButton(
                color: Colors.transparent,
                textColor: Colors.black,
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('CANCEL',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
  }




  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
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